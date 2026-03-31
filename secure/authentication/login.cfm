<cftry>
	
		<!DOCTYPE html>
		<html lang="en">
		  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1">

		    <title>Meow Meow's Succulent Garden, LLC</title>

		  </head>

		  <body>

			<cfinclude template="../page_header.cfm" >
			
			<nav class="subnav">
				<div class="container-fluid">
					<ul>			        		      				
						<li><a href="/index.cfm">Home</a></li>	  																			
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="../clear_data.cfm" >

			<cfif Not IsDefined("Session.Email_Code_Sent")>
				<cfset Session.Email_Code_Sent = 0>
			</cfif>	

			<cfif Not IsDefined("Session.Login_Status")>
				<cfset Session.Login_Status = 0>
			</cfif>	

			<cfif IsDefined("form.reset_code")>
				<cfset Session.Login_Status = 30>	
			</cfif>

			<cfif IsDefined("form.send_code")>
				<cfset Session.Login_Status = 10>	
			</cfif>			

			<cfif Not IsDefined("Session.Email_Code")>
				<cfset Session.Email_Code = 0>
			</cfif>

			<cfif Not IsDefined("Session.Code_Submitted")>
				<cfset Session.Code_Submitted = 0>
			</cfif>	

			<cfif IsDefined("form.submit_code")>
				<cfset Session.Code_Submitted = 1>
				<cfif form.auth_code EQ Session.Email_Code>
					<cfset Session.User_Authenticated = 1>
					<cfset Session.Login_Session = 1>
					<cflocation url="../index.cfm" addtoken="false">
				<cfelse>
					<div class="alert alert-danger" role="alert">
						The authentication code you entered is incorrect. Please try again.
					</div>
				</cfif>	
			</cfif>
	
			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">									
					<div class="content-wrap">						
						<cfif Session.Login_Status EQ 0>
							<cfset Session.Email_Code_Sent = 0>
							<cfset Session.User_Authenticated = 0>
							<div class="alert alert-info" role="alert">
								Click the button below to receive an authentication code via email. Please check your email and enter the code to log in.
							</div>
							<div class="row">
								<div class="col-lg-12">
									&nbsp;
								</div>
							</div>	
							<cfform method=post action="">
								<div class="form-group">
									<cfinput type="submit" value="Send Authentication Code" name="send_code" class="btn btn-primary">
								</div>
							</cfform>
						</cfif>

						<cfif Session.Login_Status EQ 10>												
							<cfquery name="get_email_number" datasource="#dsn#">
								SELECT *
								from auth_number
							</cfquery>

							<cfset Session.Email_Address = get_email_number.auth_email>

							<cfscript>
									function generateSevenDigitCode(){
										return randRange(1000000, 9999999);
									}

									code = generateSevenDigitCode();				
							</cfscript>

							<cfset Session.Email_Code = code>

							<p>
								Code sent to: #Session.Email_Address#
								<br>
								Code: #Session.Email_Code#
							</p>

							<cfmail from="meowmeowsucculent@gmail.com" subject="Auth Code" to="#Session.Email_Address#" type="html">
								Your authentication code is: #Session.Email_Code#
							</cfmail>	
							
							<cfset Session.Login_Status = 20>							
							<cflocation url="login.cfm"  addtoken="false">					
						</cfif>	

						<cfif Session.Login_Status EQ 20>	
							<div class="alert alert-info" role="alert">
								An authentication code has been sent to your email address. Please check your email and enter the code below.
							</div>
							<div class="row">
								<div class="col-lg-12">
									&nbsp;
								</div>
							</div>	
							<cfform method=post action="">
								<div class="form-group">
									<cfinput type="text" name="auth_code" placeholder="Enter Authentication Code" class="form-control">
								</div>
								<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>	
								<div class="form-group">
									<cfinput type="submit" value="Submit Code" name="submit_code" class="btn btn-primary">
								</div>
							</cfform>	

							<div class="row">
								<div class="col-lg-12">
									&nbsp;
								</div>
							</div>	
							<cfform method=post action="">								
								<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>	
								<div class="form-group">
									<cfinput type="submit" value="Reset Process" name="reset_code" class="btn btn-primary">
								</div>
							</cfform>
											
						</cfif>

						<cfif Session.Login_Status EQ 30>
							<cfset Session.Email_Code_Sent = 0>
							<cfset Session.User_Authenticated = 0>
							<cfset Session.Login_Status = 0>
							<cflocation url="login.cfm" addtoken="false">
						</cfif>

					</div>					
				</div><!--- end .container --->
		    </div><!--- end content --->
		    </cfoutput>


		    <cfinclude template="../common_footer.cfm" >

		    <cfinclude template="../js.cfm" >
			

		  </body>
	</html>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="../dump.cfm">

	</cfcatch>
</cftry>
