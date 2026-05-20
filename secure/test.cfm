
	<cfset Session.auth_api_url = "https://ucdavis.elentra.cloud/api/v2/auth/client">
	<cfset Session.api_url_path = Session.auth_api_url>
	<cfset Session.API_Username = "SOM_API">
	<cfset Session.API_Password = "r7eqw4nd$$s3K">
	<cfset Session.API_auth_username = "a8a0b7867a55a86cf176241d36e26287">
	<cfset Session.API_auth_password = "8a79a9402b123fc1443046a67cd95c1d">
	<cfset Session.API_auth_method = "local">
	<cfset Session.API_auth_app_id = "1">

	<cfset Session.page_check_url = Trim(Session.api_url_path)>
	
	<cfset Session.theurl = Trim(Session.api_url_path)>
	
	<cfset Session.Elentra_Auth_Token = "">

	<!--- Make the Get Request --->
	<cfoutput >		
		<cfscript>
			Session.JSONdata = {"auth_username"="a8a0b7867a55a86cf176241d36e26287","auth_password"="8a79a9402b123fc1443046a67cd95c1d",
			"auth_method"="local","auth_app_id"="1"};
			Session.theJSON = serializeJSON(Session.JSONdata);
		</cfscript>

		<cfhttp method="post" url="#Session.theurl#" result="result">
			<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded">
			<cfhttpparam type="formField" name="username" encoded="yes" value="SOM_API"/>
			<cfhttpparam type="formField" name="password" encoded="yes" value="r7eqw4nd$$s3K"/>
			<cfhttpparam type="formField" name="request" value="#Session.theJSON#"/>
		</cfhttp>

		<cfdump var="#result#" ><cfabort>
		
		<!--- JSON data is sometimes distributed as a JavaScript function.
		The following REReplace functions strip the function wrapper. --->
		<cfset Session.Elentra_Auth_Data = REReplace(result.FileContent, "^\s*[[:word:]]*\s*\(\s*","")>
		<cfset Session.Elentra_Auth_Data = REReplace(Session.Elentra_Auth_Data, "\s*\)\s*$", "")>
		
		<cfif Session.Elentra_Auth_Data contains "The specified resource does not exist">
			<p>
				Course Does Not Exist
			</p>
		<cfelse>
			<cfif Session.Elentra_Auth_Data contains "user not authorized to perform that action">
				<p>
					Access denied to course: #Session.Current_Working_Course_ID#
				</p>
			<cfelse>
				<cfif !IsJSON(Session.Elentra_Auth_Data)>
				    <p>
				    	The URL you requested does not provide valid JSON
				    </p>							   
				<cfelse>
					<!--- If the data is in JSON format, deserialize it. --->
					<cfset Session.Elentra_Auth_JSON = DeserializeJSON(Session.Elentra_Auth_Data)>
					
					<cfloop collection="#Session.Elentra_Auth_JSON#" item="i">
						<cfif StructKeyExists(Session.Elentra_Auth_JSON, "token")>
							<cfset Session.Elentra_Auth_Token = structGet("Session.Elentra_Auth_JSON.token")>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>

	</cfoutput>	
