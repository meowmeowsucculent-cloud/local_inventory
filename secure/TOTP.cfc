/**
 * TOTP.cfc — Time-based One-Time Password (RFC 6238 / Google Authenticator)
 *
 * Implements the full TOTP stack:
 *   - Base32 secret generation and encoding/decoding
 *   - HOTP core (RFC 4226) using HMAC-SHA1
 *   - TOTP window verification with configurable clock drift tolerance
 *   - otpauth:// URI generation for QR code provisioning
 *   - Timing-safe comparison to prevent timing attacks
 *
 * Usage:
 *   totp = new TOTP();
 *   secret = totp.generateSecret();           // store this per-user
 *   uri    = totp.getProvisioningURI(secret, "alice@example.com", "MyApp");
 *   valid  = totp.verify(secret, userInput);  // true/false
 *
 * Requirements: ColdFusion 10+ or Lucee 5+
 */
component displayname="TOTP" accessors="true" {

    // -------------------------------------------------------------------------
    // Configuration — adjust at the call site or via constructor args
    // -------------------------------------------------------------------------

    /** TOTP time step in seconds (Google Authenticator default = 30) */
    property name="timeStep"       type="numeric" default="30";

    /** Number of digits in the OTP (6 or 8) */
    property name="digits"         type="numeric" default="6";

    /** Clock-drift window: how many steps before/after now to accept */
    property name="windowSize"     type="numeric" default="1";

    /** HMAC algorithm — must be SHA1 for Google Authenticator compatibility */
    property name="algorithm"      type="string"  default="HmacSHA1";

    // Base32 alphabet (RFC 4648)
    variables.BASE32_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------

    public TOTP function init(
        numeric timeStep   = 30,
        numeric digits     = 6,
        numeric windowSize = 1,
        string  algorithm  = "HmacSHA1"
    ) {
        setTimeStep(arguments.timeStep);
        setDigits(arguments.digits);
        setWindowSize(arguments.windowSize);
        setAlgorithm(arguments.algorithm);
        return this;
    }

    // =========================================================================
    // PUBLIC API
    // =========================================================================

    /**
     * Generate a cryptographically random Base32 secret.
     * @secretBytes  Length of raw random bytes (20 = 160-bit, matches SHA1 block)
     * @returns      Base32-encoded string — store this in your user table
     */
    public string function generateSecret(numeric secretBytes = 20) {
        var raw = generateSecureRandomBytes(arguments.secretBytes);
        return base32Encode(raw);
    }

    /**
     * Verify a user-supplied OTP code against the stored secret.
     * Checks the current time step plus/minus windowSize steps to
     * tolerate clock drift between server and authenticator app.
     *
     * @secret   Base32-encoded secret stored for the user
     * @code     6- (or 8-) digit string entered by the user
     * @returns  true if valid, false otherwise
     */
    public boolean function verify(required string secret, required string code) {
        // Sanitise: strip spaces, handle numeric input
        var userCode = trim(toString(arguments.code));

        // Length check first — avoids wasted HMAC work
        if (len(userCode) != getDigits()) {
            return false;
        }

        var counter = getCurrentCounter();

        // Check current step and adjacent steps (clock drift tolerance)
        for (var offset = -getWindowSize(); offset <= getWindowSize(); offset++) {
            var expected = generateOTP(arguments.secret, counter + offset);
            if (timingSafeEquals(userCode, expected)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Generate the current TOTP code for a given secret.
     * Useful for testing and admin tooling — NOT for verification
     * (use verify() instead, which applies the drift window).
     *
     * @secret   Base32-encoded secret
     * @returns  Current OTP code as a zero-padded string
     */
    public string function getCurrentCode(required string secret) {
        return generateOTP(arguments.secret, getCurrentCounter());
    }

    /**
     * Build an otpauth:// URI suitable for encoding into a QR code.
     * Scan with Google Authenticator, Authy, 1Password, etc.
     *
     * @secret      Base32-encoded secret
     * @accountName User identifier shown in the authenticator app (e.g. email)
     * @issuer      App/service name shown in the authenticator app
     * @returns     otpauth:// URI string
     */
    public string function getProvisioningURI(
        required string secret,
        required string accountName,
        required string issuer
    ) {
        var encodedAccount = urlEncodedFormat(arguments.accountName);
        var encodedIssuer  = urlEncodedFormat(arguments.issuer);
        var label          = encodedIssuer & ":" & encodedAccount;

        return "otpauth://totp/#label#"
             & "?secret=#arguments.secret#"
             & "&issuer=#encodedIssuer#"
             & "&algorithm=SHA1"
             & "&digits=#getDigits()#"
             & "&period=#getTimeStep()#";
    }

    /**
     * Validate that a Base32 secret string is well-formed.
     * Call after user input if you allow custom secrets.
     */
    public boolean function isValidSecret(required string secret) {
        // Must only contain Base32 alphabet characters (uppercase + 2-7)
        return reFind("^[A-Z2-7]+=*$", uCase(trim(arguments.secret))) > 0
            && len(trim(arguments.secret)) >= 16; // minimum 80-bit security
    }

    // =========================================================================
    // CORE ALGORITHM (RFC 4226 HOTP + RFC 6238 TOTP)
    // =========================================================================

    /**
     * Core HOTP function (RFC 4226).
     * TOTP is simply HOTP where the counter is derived from the current time.
     *
     * @secret   Base32-encoded secret
     * @counter  8-byte counter value (time step for TOTP)
     * @returns  Zero-padded OTP string
     */
    private string function generateOTP(required string secret, required numeric counter) {
        // 1. Decode the Base32 secret to raw bytes
        var keyBytes = base32Decode(arguments.secret);

        // 2. Pack the 64-bit counter as a big-endian byte array
        var counterBytes = longToBytes(arguments.counter);

        // 3. Compute HMAC-SHA1(key, counter)
        var hmacBytes = computeHMAC(keyBytes, counterBytes);

        // 4. Dynamic truncation (RFC 4226 §5.4)
        //    offset = last nibble of the HMAC
        var offset = bitAnd(hmacBytes[arrayLen(hmacBytes)], 15); // & 0x0F

        // Extract 4 bytes starting at offset, mask the top bit (make unsigned)
        var p = (
              bitAnd(hmacBytes[offset + 1], 127) * 16777216  // << 24  (mask 0x7F)
            + bitAnd(hmacBytes[offset + 2], 255) * 65536     // << 16
            + bitAnd(hmacBytes[offset + 3], 255) * 256       // << 8
            + bitAnd(hmacBytes[offset + 4], 255)             // << 0
        );

        // 5. Compute OTP: p mod 10^digits, zero-padded
        var modulus = int(10 ^ getDigits());
        var otp     = p mod modulus;

        return numberFormat(otp, repeatString("0", getDigits()));
    }

    /**
     * Return the current TOTP counter (Unix time / time step).
     */
    private numeric function getCurrentCounter() {
        // ColdFusion's now() is local — convert to UTC epoch seconds
        var epochMs = getTickCount(); // milliseconds since CF server start — unreliable for epoch
        // Reliable approach: Java System.currentTimeMillis()
        var epochSeconds = int(createObject("java", "java.lang.System").currentTimeMillis() / 1000);
        return int(epochSeconds / getTimeStep());
    }

    // =========================================================================
    // CRYPTOGRAPHIC PRIMITIVES
    // =========================================================================

    /**
     * Compute HMAC using the configured algorithm.
     * Returns a CF byte array (signed bytes, -128..127).
     */
    private array function computeHMAC(required array keyBytes, required array counterBytes) {
        // javaCast("byte[]") requires signed bytes (-128..127).
        // Our arrays store unsigned values (0..255), so remap anything > 127.
        var signedKey     = [];
        for (var b in arguments.keyBytes) {
            arrayAppend(signedKey, b > 127 ? b - 256 : b);
        }
        var signedCounter = [];
        for (var b in arguments.counterBytes) {
            arrayAppend(signedCounter, b > 127 ? b - 256 : b);
        }

        var jKey     = createObject("java", "javax.crypto.spec.SecretKeySpec")
                           .init(javaCast("byte[]", signedKey), getAlgorithm());
        var mac      = createObject("java", "javax.crypto.Mac").getInstance(getAlgorithm());
        mac.init(jKey);
        var rawBytes = mac.doFinal(javaCast("byte[]", signedCounter));

        // Convert Java's signed bytes back to unsigned (0..255) for our bit ops
        var result = [];
        for (var b in rawBytes) {
            arrayAppend(result, b < 0 ? b + 256 : b);
        }
        return result;
    }

    /**
     * Pack a numeric counter into an 8-element byte array (big-endian / network order).
     * CF/Java integers are at most 64-bit; TOTP counters fit comfortably.
     */
    private array function longToBytes(required numeric value) {
        var bytes = [];
        var v = arguments.value;
        for (var i = 8; i >= 1; i--) {
            bytes[i] = v mod 256;
            v = int(v / 256);
        }
        return bytes;
    }

    /**
     * Generate cryptographically secure random bytes using Java's SecureRandom.
     * Returns a CF numeric array of byte values (0–255).
     */
    private array function generateSecureRandomBytes(required numeric count) {
        var sr  = createObject("java", "java.security.SecureRandom").init();
        var buf = repeatString(" ", arguments.count).getBytes(); // size the array
        sr.nextBytes(buf);
        var result = [];
        for (var b in buf) {
            arrayAppend(result, b < 0 ? b + 256 : b);
        }
        return result;
    }

    // =========================================================================
    // BASE32 ENCODING / DECODING (RFC 4648)
    // =========================================================================

    /**
     * Encode a byte array as a Base32 string (no padding — cleaner for secrets).
     */
    private string function base32Encode(required array bytes) {
        var result   = "";
        var BigInteger = createObject("java", "java.math.BigInteger");
        // Use BigInteger throughout so buffer never overflows CF's 32-bit int limit
        var buffer   = BigInteger.ZERO;
        var bitsLeft = 0;
        var BIG_256  = BigInteger.valueOf(javaCast("long", 256));
        var BIG_32   = BigInteger.valueOf(javaCast("long", 32));

        for (var b in arguments.bytes) {
            buffer   = buffer.multiply(BIG_256).add(BigInteger.valueOf(javaCast("long", b)));
            bitsLeft += 8;
            while (bitsLeft >= 5) {
                bitsLeft -= 5;
                // Shift right by bitsLeft, then mod 32 — all in BigInteger
                var shifted = buffer.shiftRight(javaCast("int", bitsLeft));
                var idx     = shifted.mod(BIG_32).intValue();
                result     &= mid(variables.BASE32_CHARS, idx + 1, 1);
            }
        }

        // Remaining bits: shift left to align to a 5-bit boundary, then mod 32
        if (bitsLeft > 0) {
            var shifted = buffer.shiftLeft(javaCast("int", 5 - bitsLeft));
            var idx     = shifted.mod(BIG_32).intValue();
            result     &= mid(variables.BASE32_CHARS, idx + 1, 1);
        }

        return result;
    }

    /**
     * Decode a Base32 string back to a numeric byte array (0–255).
     */
    private array function base32Decode(required string encoded) {
        var input    = uCase(trim(arguments.encoded));
        // Strip padding
        input        = reReplace(input, "=+$", "", "all");
        var result   = [];
        var BigInteger = createObject("java", "java.math.BigInteger");
        var buffer   = BigInteger.ZERO;
        var bitsLeft = 0;
        var BIG_32   = BigInteger.valueOf(javaCast("long", 32));
        var BIG_256  = BigInteger.valueOf(javaCast("long", 256));

        var charArray = listToArray(input, ""); // split into characters

        for (var ch in charArray) {
            var idx = find(ch, variables.BASE32_CHARS) - 1;
            if (idx < 0) {
                throw(
                    type    = "TOTP.InvalidSecret",
                    message = "Invalid Base32 character '#ch#' in secret. Secrets must contain only A-Z and 2-7."
                );
            }
            buffer   = buffer.multiply(BIG_32).add(BigInteger.valueOf(javaCast("long", idx)));
            bitsLeft += 5;
            if (bitsLeft >= 8) {
                bitsLeft -= 8;
                // Shift right by bitsLeft to get the next byte, then mod 256
                var byteVal = buffer.shiftRight(javaCast("int", bitsLeft)).mod(BIG_256).intValue();
                arrayAppend(result, byteVal);
            }
        }

        return result;
    }

    // =========================================================================
    // SECURITY UTILITIES
    // =========================================================================

    /**
     * Constant-time string comparison — prevents timing oracle attacks.
     * Always compares every character even if a mismatch is found early.
     */
    private boolean function timingSafeEquals(required string a, required string b) {
        if (len(arguments.a) != len(arguments.b)) {
            return false;
        }
        var result = 0;
        var aChars = listToArray(arguments.a, "");
        var bChars = listToArray(arguments.b, "");
        for (var i = 1; i <= arrayLen(aChars); i++) {
            // XOR the ASCII values — accumulate differences with OR
            result = bitOr(result, bitXor(asc(aChars[i]), asc(bChars[i])));
        }
        return result == 0;
    }

}
