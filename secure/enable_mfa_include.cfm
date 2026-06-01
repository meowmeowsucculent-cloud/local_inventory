<!---
    enable_mfa.cfm — MFA Enrollment Page

    Rewired to use:
      - TOTP.cfc instead of the legacy GoogleAuthenticator.cfc
      - application.enc.encryptForStorage() instead of the undefined encryptForStorage()
      - Correct query parameter names matching the INSERT columns
      - form.totpSecret replaced with the generated secret from TOTP.cfc
      - QR code URI built via totp.getProvisioningURI() instead of auth.getOTPURL()
--->

<cfscript>
    // -------------------------------------------------------------------------
    // POST — generate a new secret and store it
    // -------------------------------------------------------------------------
    if (CGI.REQUEST_METHOD EQ "POST") {

        // FIX 1: use TOTP.cfc instead of the legacy GoogleAuthenticator.cfc
        totp   = new TOTP();
        secret = totp.generateSecret();

        // FIX 2: use application.enc.encryptForStorage() — this is the correct
        // call. encryptForStorage() alone is undefined because it lives inside
        // Encryption.cfc, instantiated as application.enc in Application.cfc
        toStore = application.enc.encryptForStorage(secret, application.encryptionKey);

        // Generate a UUID for the new MFA record
        local.mfa_db_uuid = reReplace(createUUID(), "-", "", "all");

        // FIX 3: query parameter names now match the INSERT column list —
        // the original had :email and :secret but the columns are user_email
        // and secret_key, causing a silent parameter mismatch
        try {
            queryExecute(
                "INSERT INTO mfa (id, user_email, secret_key, active) VALUES (:id, :user_email, :secret_key, :active)",
                {
                    id:          { value: local.mfa_db_uuid, cfsqltype: "cf_sql_varchar" },
                    user_email:  { value: form.email,        cfsqltype: "cf_sql_varchar" },
                    secret_key:  { value: toStore,           cfsqltype: "cf_sql_varchar" },
                    active:      { value: 0,                 cfsqltype: "cf_sql_integer" }
                },
                { datasource: "SQL_Main" }
            );

            // FIX 4: store only the UUID in session — never store the raw
            // secret or encrypted value in the session scope
            session.mfa_db_uuid      = local.mfa_db_uuid;
            session.mfa_setup_email  = form.email;

            // Build the provisioning URI for the QR code
            // FIX 5: totp.getProvisioningURI() replaces auth.getOTPURL()
            // and uses the generated secret, not the missing form.totpSecret
            provisioningURI = totp.getProvisioningURI(
                secret      = secret,
                accountName = form.email,
                issuer      = "Meow Meow's Succulent Garden"
            );

            setupSuccess = true;

        } catch (any e) {
            setupError   = e.message & " | Detail: " & e.detail & " | SQL: " & e.queryError;
            setupSuccess = false;
        }
    }
</cfscript>


<!--- TEMP DEBUG — remove before going live --->
<!----
<cfif CGI.REQUEST_METHOD EQ "POST">
    <cfoutput>
        <p><strong>setupSuccess:</strong> #isDefined("setupSuccess")# / #( isDefined("setupSuccess") ? setupSuccess : "undefined" )#</p>
        <cfif isDefined("setupError")>
            <p style="color:red;"><strong>setupError:</strong> #encodeForHTML(setupError)#</p>
        </cfif>
        <cfif isDefined("provisioningURI")>
            <p><strong>provisioningURI:</strong> #encodeForHTML(provisioningURI)#</p>
        </cfif>
        <cfif isDefined("secret")>
            <p><strong>secret:</strong> #encodeForHTML(secret)#</p>
        </cfif>
    </cfoutput>
</cfif>
--->
<!--- END TEMP DEBUG --->



<!--- -------------------------------------------------------------------------
  Enrollment form — shown before and after POST
----------------------------------------------------------------------------- --->
<cfif not (isDefined("setupSuccess") and setupSuccess)>
    <h2>Enable Two-Factor Authentication</h2>

    <cfif isDefined("setupError")>
        <cfoutput>
            <p style="color:red;">An error occurred: #encodeForHTML(setupError)#</p>
        </cfoutput>
    </cfif>

    <form action="" method="POST">
        <div class="row">			
            <div class="col-sm-12">
                &nbsp;
            </div>																	
        </div>	
        <div class="row">	
            <div class="col-sm-3">
                <strong>Email Address:</strong>
            </div>		
            <div class="col-sm-4">
                <input name="email" type="email" class="form-control">
            </div>	
            <div class="col-sm-5">
                &nbsp;
            </div>																
        </div>	
        <div class="row">			
            <div class="col-sm-12">
                &nbsp;
            </div>																	
        </div>	
        <div class="row">	
            <div class="col-sm-3">
                <strong>Password:</strong>
            </div>		
            <div class="col-sm-4">
                <input name="password" type="password" class="form-control">
            </div>	
            <div class="col-sm-5">
                &nbsp;
            </div>																
        </div>	        
        <div class="row">			
            <div class="col-sm-12">
                &nbsp;
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">								
                <input type="submit" value="Set Up MFA" class="btn btn-primary"/>							
            </div>			  								
        </div>                
    </form>
</cfif>

<!--- QR code display — shown only after a successful POST --->
<cfif isDefined("setupSuccess") and setupSuccess>
    <cfoutput>
        <h2>Scan the QR Code</h2>
        <p>Open Google Authenticator (or any TOTP app) and scan the code below.</p>

        <cfset qrImageURL = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" & provisioningURI>
        <img src="#qrImageURL#" alt="MFA QR Code" width="200" height="200" />
        <p>
         &nbsp;
        </p>
        <p>Can't scan? Enter this key manually:</p>
        <p><strong>#encodeForHTML(secret)#</strong></p>

        <p>Once you have scanned the code,
           <a href="confirm_mfa.cfm">click here to confirm your setup</a>
           by entering the 6-digit code from your authenticator app.</p>
    </cfoutput>
</cfif>