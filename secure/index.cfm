<cftry>

		<!DOCTYPE html>
		<html lang="en">
		  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1">

		    <title>Meow Meow's Succulent Garden, LLC</title>

		  </head>

		  <body>
		
			<cfoutput>
		
				<header class="layout-topbar">
					<a class="logo" href="/index.cfm"><img src="/resources/images/garden.jpg" width="253" height="132" alt="Meow Meow's Succulent Garden, LLC"></a>  
				
					<h1 class="app-title">Meow Meow's Succulent Garden, LLC</h1>
				
					<div class="topbar-navigation">						
						<cfinclude template="common_hamburger.cfm" >					
					</div>
				</header>
				
		    </cfoutput>

		    <!--- clear page values, set defaults ---->		    
		    <cfinclude template="clear_data.cfm" >
			
			<cfoutput>
		    <div id="content">
		      <div class="container">

				<div class="landing-menu">
					<div class="content-wrap">
						<div class="menu-title">
							Main Menu
						</div>

						<ul class="nav-links">				
							<li><a href="view_annual_summary.cfm">Annual Summary</a></li>	 
							<li><a href="manage_expenses.cfm">Manage Expenses</a></li>
							<li><a href="manage_inventory.cfm">Manage Inventory</a></li>
							<li><a href="manage_inventory_loss.cfm">Manage Inventory Loss</a></li>
							<li><a href="manage_sales.cfm">Manage Sales</a></li>					
							<li><a href="list_management.cfm">List Management</a></li>	   				
						</ul>
					</div>
				</div>

		      </div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>

		    <cfinclude template="common_footer.cfm" >

		    <cfinclude template="js.cfm" >

		  </body>
		</html>


	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
