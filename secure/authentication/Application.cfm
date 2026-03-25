<cftry>
	<cfsetting requesttimeout="0">
	<!---
	applicationTimeout = #CreateTimeSpan(days, hours, minutes, seconds)#
	---->
	<CFAPPLICATION NAME="meow_succulent"
	SESSIONTIMEOUT=#CreateTimeSpan(0, 4, 0, 0)#
	SESSIONMANAGEMENT="yes"
	SETCLIENTCOOKIES="yes"
	clientstorage="SQL_ClientVariables"
	scriptProtect = "all" >


	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
		<head>
	
			<title>Meow Meow's Succulent Garden, LLC</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		
			<meta http-equiv="cache-control" content="no-cache" />
			<meta http-equiv="expires" content="0" />
			<meta http-equiv="Pragma" content="no-cache">
	
			<META NAME="ROBOTS" CONTENT="NONE">
			<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

			<cfinclude template="../css.cfm">
		</head>
		
	</html>
	
	<cfset this.scriptprotect="all">


	<cfinclude template="../dsn.cfm">
	<cfinclude template="../system_settings.cfm" >

	<cfajaximport tags="cfform">

	<cfinclude template="../ver.cfm">

	<cfset Session.DateNow = DateFormat(Now(), "mm/DD/yyyy")>
	<cfset Session.CurrentDateNow = DateFormat(Now(), "mm/DD/yyyy")>
	<cfset Session.CurrentTimeNow = TimeFormat(Now(), "hh:mm tt")>
	<cfset Session.Current_C_Year = DatePart("yyyy", Session.CurrentDateNow)>

	<cfset Session.CurrentLogTime = TimeFormat(Now(), "hh:mm:ss")>
	<cfset Session.CurrentLogDate = DateFormat(Now(), "yyyy-mm-dd")>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="../dump.cfm">
	</cfcatch>
</cftry>
