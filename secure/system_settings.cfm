
<cfset Session.Reply_Email = "meowmeowsucculent@gmail.com">
<cfset Session.No_Reply_Email = Session.Reply_Email>

<cfset Session.Current_Year = DateFormat(Now(), "mm/DD/yyyy")>
<cfset Session.current_report_year = DatePart("yyyy", Session.Current_Year)>
<cfset Session.DateNow = DateFormat(Now(),"mm/DD/yyyy")>
<cfset Session.TimeNow = Timeformat(Now(), "hh:mm tt")>
<cfset Session.CurrentYear = DatePart("yyyy", Now())>
<cfset Session.CurrentDate = DateFormat(Now(), "mm/dd/yyyy")>
<cfset Session.CurrentLogDate = DateFormat(Now(), "mm/dd/yyyy")>
<cfset Session.CurrentLogTime = Timeformat(Now(), "hh:mm tt")>

<cfset Session.Current_Date_Time = Session.DateNow & " " & Session.TimeNow>

<cfset Session.CurrentYear = DatePart("yyyy", Now())>
<cfset Session.CurrentMonth = DatePart("m", Now())>
<cfset Session.CurrentLogTime = TimeFormat(Now(), "hh:mm:ss")>
<cfset Session.CurrentLogDate = DateFormat(Now(), "yyyy-mm-dd")>

<CFPARAM NAME = "Session.User_Authenticated" default="0">
<CFPARAM NAME = "Session.Login_Session" default="0">
<CFPARAM NAME = "Session.Email_Code_Sent" default="0">

<CFPARAM NAME = "Session.SERVER_NODE" default="">
<CFPARAM NAME = "Session.ENABLE_GLOBAL_EMAIL" DEFAULT = "1">
<CFPARAM NAME = "Session.Session_Management_Expire" default="50">
<CFPARAM NAME = "Session.Expire_Session_Message" default="">

<CFPARAM NAME = "Session.Server_Host_IP" DEFAULT = "">
<CFPARAM NAME = "Session.appver" DEFAULT = "">
