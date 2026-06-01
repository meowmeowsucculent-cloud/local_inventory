<cftry>

	<!DOCTYPE html>
	<html lang="en">
	  <head>
	    <meta charset="utf-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	    <title>Meow Meow's Succulent Garden, LLC</title>
	  </head>

	  <body>

		<cfinclude template="../page_header.cfm">

		<nav class="subnav">
			<div class="container-fluid">
				<ul>
					<li><a href="/index.cfm">Home</a></li>
				</ul>
			</div>
		</nav>

		<!---
			SECURITY GATE: If the user has not passed email code authentication,
			or MFA session vars are missing, boot them back to login.
		--->
		<cfif NOT isDefined("session.User_Authenticated") OR session.User_Authenticated NEQ 1>
			<cflocation url="login.cfm" addtoken="false">
		</cfif>

		<cfif NOT isDefined("session.mfa_db_uuid") OR NOT isDefined("session.mfa_setup_email")>
			<cflocation url="login.cfm" addtoken="false">
		</cfif>

		<!--- Initialize status vars --->
		<cfparam name="session.mfa_verify_attempts" default="0">
		<cfparam name="session.mfa_auth_success"    default="0">

		<cfset verifyError   = "">
		<cfset verifySuccess = false>

		<!--- Handle form submission --->
		<cfif isDefined("form.verify_mfa_code")>

			<cfset submittedCode = Trim(form.totp_code)>

			<!--- Validate input — must be exactly 6 digits --->
			<cfif NOT reFind("^\d{6}$", submittedCode)>
				<cfset verifyError = "Please enter a valid 6-digit code.">

			<!--- Lock out after 5 failed attempts --->
			<cfelseif session.mfa_verify_attempts GTE 5>
				<cfset verifyError = "Too many failed attempts. Please log in again.">
				<cfset session.User_Authenticated = 0>
				<cfset session.mfa_verify_attempts = 0>
				<cflocation url="login.cfm" addtoken="false">

			<cfelse>
				<cftry>
					<!--- Fetch the secret key for this user from the database --->
					<cfset mfaRow = queryExecute(
						"SELECT secret_key
						   FROM mfa
						  WHERE id         = :id
						    AND user_email = :user_email
						    AND active     = 1",
						{
							id:         { value: session.mfa_db_uuid,     cfsqltype: "cf_sql_varchar" },
							user_email: { value: session.mfa_setup_email, cfsqltype: "cf_sql_varchar" }
						},
						{ datasource: "SQL_Main" }
					)>

					<cfif mfaRow.recordCount EQ 0>
						<cfset verifyError = "MFA record not found. Please contact support.">
					<cfelse>
						<cfset secretKey = Trim(mfaRow.secret_key)>

                        <!--- Decrypt the secret — it was encrypted before storage in enable_mfa_include.cfm --->
                        <cfset secretKey = application.enc.decryptFromStorage(secretKey, application.encryptionKey)>

						<!---
							Validate the TOTP code using the same library used in enable_mfa.cfm.
							Accepts a 1-period window (30 seconds before and after) to account
							for clock drift.
						--->
						<cfset totp       = createObject("component", "totp")>
						<cfset codeValid  = totp.verify(secretKey, submittedCode, 1)>

						<cfif codeValid>
							<!--- Success — mark MFA as passed and send to dashboard --->
							<cfset session.mfa_auth_success    = 1>
							<cfset session.mfa_verify_attempts = 0>

							<!--- Log the successful MFA login timestamp --->
							<cfset queryExecute(
								"UPDATE mfa
								    SET last_used = :last_used
								  WHERE id        = :id",
								{
									last_used: { value: now(),                cfsqltype: "cf_sql_timestamp" },
									id:        { value: session.mfa_db_uuid,  cfsqltype: "cf_sql_varchar"  }
								},
								{ datasource: "SQL_Main" }
							)>

							<cflocation url="../index.cfm" addtoken="false">

						<cfelse>
							<!--- Wrong code — increment attempt counter --->
							<cfset session.mfa_verify_attempts = session.mfa_verify_attempts + 1>
							<cfset attemptsLeft = 5 - session.mfa_verify_attempts>
							<cfset verifyError  = "Invalid code. You have #attemptsLeft# attempt(s) remaining.">
						</cfif>
					</cfif>

				<cfcatch type="any">
					<cfset verifyError = "An error occurred verifying your code. Please try again. (" & encodeForHTML(cfcatch.message) & ")">
				</cfcatch>
				</cftry>
			</cfif>
		</cfif>

		<cfoutput>
		<div id="content">
			<div class="container-fluid">
				<div class="content-wrap">

					<div class="row">
						<div class="col-lg-12">
							<h4>Two-Factor Authentication</h4>
							<p>Enter the 6-digit code from your authenticator app to complete sign-in.</p>
						</div>
					</div>

					<div class="row">
						<div class="col-lg-12">
							&nbsp;
						</div>
					</div>

					<!--- Show error if present --->
					<cfif len(verifyError)>
						<div class="alert alert-danger" role="alert">
							#encodeForHTML(verifyError)#
						</div>
						<div class="row">
							<div class="col-lg-12">
								&nbsp;
							</div>
						</div>
					</cfif>

					<!--- MFA code entry form --->
					<cfform method="post" action="verify_mfa.cfm">
						<div class="row">
							<div class="col-sm-3">
								<strong>Authenticator Code:</strong>
							</div>
							<div class="col-sm-4">
								<cfinput
									type        = "text"
									name        = "totp_code"
									placeholder = "Enter 6-digit code"
									class       = "form-control"
									maxlength   = "6"
									autocomplete= "one-time-code"
									inputmode   = "numeric"
									pattern     = "[0-9]{6}"
									required    = "true">
							</div>
						</div>

						<div class="row">
							<div class="col-lg-12">
								&nbsp;
							</div>
						</div>

						<div class="row">
							<div class="col-sm-12">
								<cfinput type="submit" name="verify_mfa_code" value="Verify Code" class="btn btn-primary">
								&nbsp;
								<a href="login.cfm" class="btn btn-outline-secondary">Cancel &amp; Return to Login</a>
							</div>
						</div>
					</cfform>

					<div class="row">
						<div class="col-lg-12">
							&nbsp;
						</div>
					</div>

					<div class="alert alert-info" role="alert">
						<strong>Tip:</strong> Codes refresh every 30 seconds. If your code is rejected, wait for the next one and try again.
					</div>

				</div>
			</div><!--- end .container --->
		</div><!--- end content --->
		</cfoutput>

		<cfinclude template="../common_footer.cfm">
		<cfinclude template="../js.cfm">

	  </body>
	</html>

	<cfcatch type="any">
		<cfinclude template="../dump.cfm">
	</cfcatch>
</cftry>
