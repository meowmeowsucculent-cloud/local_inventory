<cfparam name="request.dumpMode" default="SECURE" type="string">
	
<cfset Session.CurrentDateNow = DateFormat(Now(), "mm/DD/yyyy")>
<cfset Session.CurrentTimeNow = TimeFormat(Now(), "hh:mm tt")>

<cfset Session.Send_Error_Report = 1>

<cflock scope="SERVER" type="READONLY" timeout="10">
	<cfset variables.CFVer=Left(server.coldfusion.ProductVersion,1)>
</cflock>	

<cfset Session.Application_Name = "Meow_Succulent">

<cfset Session.Server_Env = #Session.Application_Name# & " Error - Prod">

<cfset Session.e_dir = "e:/temp/errors/">
<cfset e_dir = Session.e_dir>
<cfset e_domain = #cgi.SERVER_NAME#>

<cfscript>
	request.vars="CFCATCH,CGI,FORM,SESSION,URL";
	request.theFileName=Replace(CreateUUID(),"-","","all");
	request.errorDirectory="#e_dir#";
	request.errorDomain="#e_domain#";
</cfscript>

<cfif Not IsDefined("Session.error_file_name")>
	<cfset Session.error_file_name = request.errorDomain>
</cfif>

<cfif Not IsDefined("Session.e_dir")>
	<cfset Session.e_dir = request.errorDirectory>
</cfif>

<!---
https://helpx.adobe.com/coldfusion/cfml-reference/reserved-words-and-variables/coldfusion-tag-specific-variables/cfcatch-variables.html
--->

<cfsavecontent variable="variables.dataDump">
	<cfdump var="#CFCATCH.Detail#" label="Detail">
	<br>
	<cfdump var="#CFCATCH.Message#" label="Message">
	<br>
	<cfif IsDefined("CFCATCH.TagContext")>
		<br><br>
		<cfdump var="#CFCATCH.TagContext#" label="TagContext">
	</cfif>	
	<br><br>
	<cfdump var="#CGI#" label="CGI">
	<br><br>
	<cfdump var="#FORM#" label="FORM">
	<br><br>
	<cfdump var="#SESSION#" label="SESSION">
	<br><br>

</cfsavecontent>

<cfsavecontent variable="variables.sessionDump">	
	<cfdump var="#SESSION#" label="SESSION">
</cfsavecontent>	
<cfsavecontent variable="variables.detailDump">	
	<cfdump var="#CFCATCH.Detail#" label="Detail">
</cfsavecontent>	
<cfsavecontent variable="variables.MessageDump">	
	<cfdump var="#CFCATCH.Message#" label="Message">
</cfsavecontent>	
<cfsavecontent variable="variables.CGIDump">	
	<cfdump var="#CGI#" label="CGI">
</cfsavecontent>
<cfsavecontent variable="variables.FormDump">	
	<cfdump var="#FORM#" label="FORM">
</cfsavecontent>


<cfdump var="#CFCATCH.Detail#" label="Detail">
<br>
<cfdump var="#CFCATCH.Message#" label="Message">

<cfset Session.error_file_name = "Meow_Succulent_" & rereplace(createuuid(),"-","","all")>

<cffile action="write" file="#Session.e_dir##Session.error_file_name#.html" output="#variables.dataDump#">

<!----
<cfmail from="meowmeowsucculent@gmail.com" subject="App Error" to="meowmeowsucculent@gmail.com" type="html">
	Error
</cfmail>
--->