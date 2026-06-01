<!---
    confirm_mfa.cfm — MFA Enrollment Confirmation

    Called after enable_mfa.cfm. Asks the user to enter their first 6-digit
    code from their authenticator app to verify the secret was scanned/entered
    correctly before marking MFA as active in the database.

    Requires:
      - session.mfa_db_uuid      set by enable_mfa.cfm
      - session.mfa_setup_email  set by enable_mfa.cfm
      - application.enc          Encryption.cfc instance from Application.cfc
      - application.encryptionKey AES key from Application.cfc
      - TOTP.cfc                 in the same directory or a mapped path
--->

<cfscript>

    // -------------------------------------------------------------------------
    // Guard — if the session vars from enable_mfa.cfm are missing, the user
    // hasn't gone through enrollment. Send them back.
    // -------------------------------------------------------------------------
    if (!structKeyExists(session, "mfa_db_uuid") || !structKeyExists(session, "mfa_setup_email")) {
        location(url="enable_mfa.cfm", addToken=false);
        abort;
    }

    // -------------------------------------------------------------------------
    // POST — verify the code the user entered
    // -------------------------------------------------------------------------
    if (CGI.REQUEST_METHOD EQ "POST") {

        // Basic input sanity check before hitting the DB
        local.userCode = trim(form.otp_code ?: "");

        if (!len(local.userCode) || !isNumeric(local.userCode) || len(local.userCode) NEQ 6) {
            verifyError = "Please enter the 6-digit code from your authenticator app.";

        } else {

            try {
                // Fetch the encrypted secret for this enrollment record
                local.mfaRow = queryExecute(
                    "SELECT secret_key
                       FROM mfa
                      WHERE id         = :id
                        AND user_email = :user_email
                        AND active     = 0",
                    {
                        id:         { value: session.mfa_db_uuid,     cfsqltype: "cf_sql_varchar" },
                        user_email: { value: session.mfa_setup_email, cfsqltype: "cf_sql_varchar" }
                    },
                    { datasource: "SQL_Main" }
                );

                if (!local.mfaRow.recordCount) {
                    // Record not found or already activated — restart enrollment
                    verifyError = "Enrollment record not found. Please start setup again.";

                } else {

                    // Decrypt the stored secret for verification
                    local.secret = application.enc.decryptFromStorage(
                        local.mfaRow.secret_key,
                        application.encryptionKey
                    );

                    // Verify the code against the decrypted secret
                    totp = new TOTP();

                    if (totp.verify(local.secret, local.userCode)) {

                        // ✅ Code is valid — mark MFA as active in the DB
                        queryExecute(
                            "UPDATE mfa
                                SET active         = 1,
                                    activated_date = :activated_date
                              WHERE id             = :id
                                AND user_email     = :user_email",
                            {
                                activated_date: { value: now(),                       cfsqltype: "cf_sql_timestamp" },
                                id:             { value: session.mfa_db_uuid,         cfsqltype: "cf_sql_varchar"   },
                                user_email:     { value: session.mfa_setup_email,     cfsqltype: "cf_sql_varchar"   }
                            },
                            { datasource: "SQL_Main" }
                        );

                        // Mark MFA as verified for this session
                        session.mfa_enabled   = true;
                        session.mfaVerified   = true;
                        session.mfaVerifiedAt = now();

                        // Clean up enrollment session vars — no longer needed
                        structDelete(session, "mfa_db_uuid");
                        structDelete(session, "mfa_setup_email");

                        verifySuccess = true;

                    } else {
                        // ❌ Wrong or expired code
                        // Increment failed attempt counter to support rate limiting
                        session.mfa_confirm_attempts = (session.mfa_confirm_attempts ?: 0) + 1;

                        if (session.mfa_confirm_attempts GTE 5) {
                            // Too many failures — delete the pending enrollment and restart
                            queryExecute(
                                "DELETE FROM mfa WHERE id = :id AND active = 0",
                                { id: { value: session.mfa_db_uuid, cfsqltype: "cf_sql_varchar" } },
                                { datasource: "SQL_Main" }    // <-- this was missing
                            );
                            structDelete(session, "mfa_db_uuid");
                            structDelete(session, "mfa_setup_email");
                            structDelete(session, "mfa_confirm_attempts");
                            location(url="enable_mfa.cfm?error=toomanyattempts", addToken=false);
                            abort;
                        }

                        verifyError = "Invalid or expired code. Please try again. ("
                                    & session.mfa_confirm_attempts
                                    & " of 5 attempts used)";
                    }
                }

            } catch (any e) {
                verifyError = e.message & " | " & e.detail;
            }
        }
    }

</cfscript>

<!--- -------------------------------------------------------------------------
  Success state — MFA confirmed and activated
----------------------------------------------------------------------------- --->
<cfif isDefined("verifySuccess") and verifySuccess>
    <cfoutput>
        <h2>MFA Setup Complete</h2>
        <p>Your authenticator app is confirmed and two-factor authentication
           is now active on your account.</p>
        <p>From now on you will be asked for a 6-digit code each time you log in.</p>
        <cfset Session.mfa_auth_success = 1>
		<cfset Session.mfa_enabled = true>
        <p><a href="index.cfm">Continue to the application</a></p>
    </cfoutput>

<!--- -------------------------------------------------------------------------
  Verification form — shown on GET and after a failed POST
----------------------------------------------------------------------------- --->
<cfelse>
    <cfoutput>
        <h2>Confirm Your Authenticator App</h2>
        <p>Enter the 6-digit code currently shown in your authenticator app
           to confirm your setup is working correctly.</p>

        <cfif isDefined("verifyError")>
            <p style="color:red;">#encodeForHTML(verifyError)#</p>
        </cfif>

        <form action="" method="POST" autocomplete="off">
            <div class="row">			
                <div class="col-sm-12">
                    &nbsp;
                </div>																	
            </div>	

            <div class="row">	
                <div class="col-sm-2">
                    <strong>6-Digit Code:</strong>
                </div>		
                <div class="col-sm-3">
                    <input class="form-control" type="text"
                       name="otp_code"
                       id="otp_code"
                       maxlength="6"
                       inputmode="numeric"
                       pattern="[0-9]{6}"
                       autocomplete="one-time-code"
                       required 
                       />
                </div>	
                <div class="col-sm-7">
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
                    <input type="submit" value="Confirm" class="btn btn-primary"/>							
                </div>			  								
            </div>  

            <div class="row">			
                <div class="col-sm-12">
                    &nbsp;
                </div>
            </div>

            <div class="row">
                <div class="col-sm-12">								
                    <a href="enable_mfa.cfm">Start over</a>							
                </div>			  								
            </div> 
        </form>

        <p><small>The code changes every 30 seconds. If it keeps failing,
           make sure your device clock is set to automatic/network time.</small></p>
    </cfoutput>
</cfif>
