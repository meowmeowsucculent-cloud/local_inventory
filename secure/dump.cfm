<!---
    dump.cfm — Global error handler
    Called from Application.cfc onError() and onRequestStart() catch blocks.

    The exception object is available as either:
      - arguments.exception  (when called from onError)
      - cfcatch              (when called from a try/catch block)
    We normalize both into a single local variable below.
--->

<!--- Normalize the exception source into one local variable --->
<cfif isDefined("arguments.exception")>
    <cfset local.err = arguments.exception>
<cfelseif isDefined("cfcatch")>
    <cfset local.err = cfcatch>
<cfelse>
    <!--- Fallback: build a minimal struct so the rest of the file won't break --->
    <cfset local.err = {
        message    : "Unknown error — no exception object was passed to dump.cfm",
        detail     : "",
        type       : "Unknown",
        tagContext : []
    }>
</cfif>

<!--- -------------------------------------------------------------------------
  Configuration
----------------------------------------------------------------------------- --->
<cfset local.appName   = "Meow_Succulent">
<cfset local.e_dir     = "e:/temp/errors/">
<cfset local.e_domain  = cgi.SERVER_NAME>

<!--- Ensure the error directory exists --->
<cfif not directoryExists(local.e_dir)>
    <cftry>
        <cfset directoryCreate(local.e_dir)>
        <cfcatch type="any"><!--- silently skip if permissions deny creation ---></cfcatch>
    </cftry>
</cfif>

<!--- -------------------------------------------------------------------------
  Session date/time (safe — session scope may not exist in onError context)
----------------------------------------------------------------------------- --->
<cftry>
    <cfset session.CurrentDateNow = dateFormat(now(), "mm/DD/yyyy")>
    <cfset session.CurrentTimeNow = timeFormat(now(), "hh:mm tt")>
    <cfcatch type="any"><!--- session scope unavailable, skip ---></cfcatch>
</cftry>

<!--- -------------------------------------------------------------------------
  Build the error dump content
----------------------------------------------------------------------------- --->
<cfsavecontent variable="local.dataDump">
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <title>#local.appName# Error Report</title>
        <style>
            body { font-family: Arial, sans-serif; font-size: 13px; padding: 20px; }
            h2   { color: #cc0000; }
            hr   { margin: 20px 0; }
        </style>
    </head>
    <body>
        <h2>#local.appName# — Error Report</h2>
        <p><strong>Server:</strong> #local.e_domain#</p>
        <p><strong>Date/Time:</strong> #dateFormat(now(), "yyyy-mm-dd")# #timeFormat(now(), "HH:mm:ss")#</p>
        <p><strong>Page:</strong> #htmlEditFormat(cgi.SCRIPT_NAME)#</p>
        <hr>

        <cfdump var="#local.err.message#"    label="Message">
        <br>
        <cfdump var="#local.err.detail#"     label="Detail">
        <br>
        <cfdump var="#local.err.type#"       label="Type">

        <cfif structKeyExists(local.err, "tagContext") and isArray(local.err.tagContext) and arrayLen(local.err.tagContext)>
            <br>
            <cfdump var="#local.err.tagContext#" label="Tag Context">
        </cfif>

        <hr>
        <cfdump var="#cgi#"  label="CGI">
        <br>

        <cftry>
            <cfdump var="#form#" label="FORM">
            <cfcatch type="any"></cfcatch>
        </cftry>
        <br>

        <cftry>
            <cfdump var="#session#" label="SESSION">
            <cfcatch type="any"></cfcatch>
        </cftry>

    </body>
    </html>
</cfsavecontent>

<!--- -------------------------------------------------------------------------
  Write the error log file
----------------------------------------------------------------------------- --->
<cfset local.errorFileName = local.appName & "_" & reReplace(createUUID(), "-", "", "all")>
<cfset local.errorFilePath = local.e_dir & local.errorFileName & ".html">

<cfoutput >
    <cftry>
        <cffile action="write"
                file      = "#local.errorFilePath#"
                output    = "#local.dataDump#"
                charset   = "utf-8">
        <cfcatch type="any">
            <!--- File write failed — log to CF's own log as a fallback --->
            <cflog file="application"
                type="error"
                text="dump.cfm could not write error file: #cfcatch.message#. Original error: #local.err.message#">
        </cfcatch>
    </cftry>

</cfoutput>

<!--- -------------------------------------------------------------------------
  Display a safe, user-facing error message
  (never expose raw error details to end users in production)
----------------------------------------------------------------------------- --->
<cfoutput>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <title>#local.appName# — An Error Occurred</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body  { font-family: Arial, sans-serif; text-align: center; padding: 60px 20px; background: ##f9f9f9; }
            h1    { color: ##cc0000; }
            p     { color: ##555; font-size: 15px; }
            small { color: ##999; font-size: 12px; }
        </style>
    </head>
    <body>
        <h1>Something went wrong</h1>
        <p>An unexpected error occurred. The issue has been logged and will be reviewed.</p>
        <p><a href="/">Return to the home page</a></p>
        <small>Error ID: #local.errorFileName#</small>
    </body>
    </html>
</cfoutput>
