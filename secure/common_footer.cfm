<cfset Current_Year = DateFormat(Now(), "mm/DD/yyyy")>
<cfset Current_C_Year = DatePart("yyyy", Current_Year)>

<cfoutput >
	<footer>
	  <div class="container">
	    <p>&copy;#Current_C_Year# Meow Meow's Succulent Garden, LLC. All Rights Reserved.</p>
	    <p>#Session.appver# </p>
	    <p>IP: #cgi.REMOTE_ADDR#</p>
	  </div>
	</footer>
</cfoutput>


