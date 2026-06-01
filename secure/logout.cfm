<cftry>
	
		<!DOCTYPE html>
		<html lang="en">
		  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1">

		    <title>Meow Meow's Succulent Garden, LLC</title>

		  </head>

		  <body>

			<cfinclude template="page_header.cfm" >
			
			<nav class="subnav">
				<div class="container-fluid">
					<ul>			        		      				
						<li><a href="index.cfm">Home</a></li>	  
																			
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfset Session.Display_Filtered_Data = 1>

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      							      	
				      	</ol>
				    </div>				

					<div class="content-wrap">
						<cfset Session.Email_Code_Sent = 0>
						<cfset Session.User_Authenticated = 0>
						<cfset Session.mfa_auth_success = 0> 
						<cfset Session.Login_Session = 0>
						<cfset Session.mfa_auth_success = 0> 
						<cfset Session.Login_Status = 0>
						<cfset Session.Email_Code = 0>
						<cfset Session.Code_Submitted = 0>
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>


		    <cfinclude template="common_footer.cfm" >

		    <cfinclude template="js.cfm" >

			<!----
			<div class="row">
				<div class="col-lg-12">
				</div>
			</div>
			
			<div>
				<div class="alert alert-success">
				
				</div>
			</div>
			
			<cfqueryparam value="" cfsqltype="cf_sql_longvarchar" >		
			
			<cfqueryparam value="" cfsqltype="cf_sql_integer" >
			
					<cfqueryparam value="" cfsqltype="cf_sql_longvarchar" >		
			
			<cfqueryparam value="" cfsqltype="cf_sql_integer" >
			
			<cfset Session.Quality_Check_Field = Trim(ReReplaceNoCase(#Session.Quality_Check_Field#,"[^0-9a-zA-Z ]","","ALL"))>
			\w denotes [A-Za-z0-9_]
			email = ^[-\w.]+@[\w]+\.[\w]+$
			^[a-zA-Z0-9_\\.\\-]+@[a-zA-Z0-9_]+\\.[a-zA-Z0-9_]+$
			[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]
			
			Trim(ReReplaceNoCase(#Session.room_config_notes#,"[^0-9a-zA-Z_,\.\-\&]","","ALL"))>
			https://stackoverflow.com/questions/37010701/add-dash-to-java-regex

			Should solve your problem. In regex you need to escape anything that has meaning in the Regex engine (eg. -, ?, *, etc.).
			
			<cfset Session.room_config_notes = Trim(encodeForHTML(Session.room_config_notes))>
			
			<a class="action-icon" href="edit_request.cfm?type=software&mode=edit&Request_ID=#PendingLookUp.Request_ID#"  style="text-decoration:none;">
				<i class="bi bi-pencil-square" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Edit Request" aria-label="Edit Request">
				</i>
			</a>
			--->

		  </body>
	</html>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
