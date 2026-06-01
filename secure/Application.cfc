component displayname="Application" {

    // -------------------------------------------------------------------------
    // Application settings (replaces <cfapplication> tag)
    // -------------------------------------------------------------------------
    this.name              = "meow_succulent";
    this.sessionManagement = true;
    this.sessionTimeout    = createTimeSpan(0, 4, 0, 0);
    this.setClientCookies  = true;
    this.clientStorage     = "SQL_ClientVariables";
    this.scriptProtect     = "all";

    // -------------------------------------------------------------------------
    // onApplicationStart — runs once when the application first starts
    // -------------------------------------------------------------------------
    boolean function onApplicationStart() {
        try {
            // DSN and system settings loaded once at startup
            include "dsn.cfm";
            include "system_settings.cfm";

            this.datasource = application.DSN;   // move it here, inside try

            // FIX 1: moved inside try/catch so failures are caught and logged
            // FIX 1: guard against missing environment variable
            local.aesKey = server.system.environment["MYAPP_AES_KEY"] ?: "";
            if (!len(trim(local.aesKey))) {
                throw(
                    type    = "Application.ConfigError",
                    message = "MYAPP_AES_KEY environment variable is not set. Application cannot start."
                );
            }
            application.encryptionKey = local.aesKey;
            application.enc           = new Encryption();

        } catch (any e) {
            cflog(
                file = "application",
                type = "error",
                text = "onApplicationStart failed: #e.message# — #e.detail#"
            );
            include "dump.cfm";
            return false;
        }        
        return true;
    }

    // -------------------------------------------------------------------------
    // onSessionStart — runs once per new user session
    // -------------------------------------------------------------------------
    boolean function onSessionStart() {
        session.User_Authenticated = false;
        return true;
    }

    // -------------------------------------------------------------------------
    // onRequestStart — runs at the beginning of every page request.
    // Outputs the opening HTML shell so every page gets consistent
    // <head> content without needing onRequest() (which blocks direct
    // .cfm template execution in CF 2025).
    // -------------------------------------------------------------------------
    boolean function onRequestStart(required string targetPage) {
        try {                   
            
            // FIX 3: guard against missing application scope vars from a failed startup
            if (!structKeyExists(application, "enc") 
                || !structKeyExists(application, "encryptionKey")
                || !structKeyExists(application, "DSN")) {
                throw(
                    type    = "Application.NotReady",
                    message = "Application failed to initialize correctly. Check application logs."
                );
            }

            
            // FIX 4: safely check session variable with isDefined before relying on it
            if (!structKeyExists(session, "User_Authenticated")) {
                session.User_Authenticated = false;
            }

            // Make DSN available in session scope for all templates
            session.DSN = application.DSN;

            // Set request-level date/time values used across templates
            session.DateNow        = dateFormat(now(), "mm/DD/yyyy");
            session.CurrentDateNow = dateFormat(now(), "mm/DD/yyyy");
            session.CurrentTimeNow = timeFormat(now(), "hh:mm tt");
            session.Current_C_Year = datepart("yyyy", now());
            session.CurrentLogTime = timeFormat(now(), "hh:mm:ss");
            session.CurrentLogDate = dateFormat(now(), "yyyy-mm-dd");

            // Redirect unauthenticated users to login (except for the login page itself)
            if (!session.User_Authenticated
                && !findNoCase("login.cfm", arguments.targetPage)
                && !findNoCase("authentication/", arguments.targetPage)) {
                location(url="authentication/login.cfm", addToken=false);
                return false;
            }

            // FIX 5: include ver.cfm BEFORE writing any HTML output so that
            // if it throws, dump.cfm can render a clean error page
            include "ver.cfm";

            // Output opening HTML shell
            writeOutput('<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <title>Meow Meow''s Succulent Garden, LLC</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="ROBOTS" content="NONE" />
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />');

            // CSS links included from css.cfm
            include "css.cfm";

            writeOutput('</head>
<body>');

        } catch (any e) {
            include "dump.cfm";
            return false;
        }
        return true;
    }

    // -------------------------------------------------------------------------
    // onRequestEnd — runs at the end of every page request.
    // Closes the HTML shell opened in onRequestStart.
    // FIX 2: no arguments — onRequestEnd() takes none in CF 2025
    // -------------------------------------------------------------------------
    void function onRequestEnd() {
        writeOutput('</body>
</html>');
    }

    // -------------------------------------------------------------------------
    // onError — global error handler (replaces <cftry>/<cfcatch> wrapper)
    // -------------------------------------------------------------------------
    void function onError(required any exception, required string eventName) {
        include "dump.cfm";
    }

}
