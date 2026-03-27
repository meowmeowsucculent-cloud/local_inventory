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
						<li><a href="add_new_sales.cfm" class="active">Add New Sale</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfif Not IsDefined("Session.New_Sales_Page_Status")>
				<cfset Session.New_Sales_Page_Status = 0>				
			</cfif>

			<cfif IsDefined("Form.sales_step_1")>
				<cfset Session.New_Sales_Page_Status = 10>
				<cfset Session.New_Sales_Inventory_ID = Form.Inventory>
			</cfif>	

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_sales.cfm">Manage Sales</a></li>
							<li><a href="add_new_sales.cfm" class="active">Add New Sale</a></li>					      	
				      	</ol>
				    </div>				
					
					<div class="content-wrap">	

						<cfquery name="get_inventory" datasource="#DSN#">
							select i.*, lm.description, lm.type
							from inventory i
							inner join list_management lm
							on i.category_id = lm.id and lm.type = 'category'
							where lm.active = '1'
							and lm.type = 'category'
							and i.on_hand_qty > '0'
						</cfquery>

						<cfquery name="get_expense_category" datasource="#DSN#">
							select *
							from list_management
							where type = 'Expense'
							and active = '1'
							Order by description
						</cfquery>

						<cfquery name="get_vendor" datasource="#DSN#">
							select *
							from list_management
							where type = 'vendor'
							and active = '1'
							Order by description
						</cfquery>

						<cfquery name="get_payment_method" datasource="#DSN#">
							select *
							from list_management
							where type = 'payment method'
							and active = '1'
							Order by description
						</cfquery>					

						<cfif Session.New_Sales_Page_Status EQ 0>
							<cfform method=post action="add_new_sales.cfm">								
								<div class="content-wrap">
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Select Inventory:</strong>
										</div>
										<div class="col-sm-5">									
											<cfselect name="inventory" size="1" class="form-select" onChange="loadPage(this)" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_inventory">
													<option value="#Trim(get_inventory.id)#">#Trim(get_inventory.description)#</option>
												</cfloop>										
											</cfselect>
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="sales_step_1" value="Next" class="btn btn-primary">
																														
										</div>			  								
									</div>
								</div>	
							</cfform>
						</cfif>

						<cfif Session.New_Sales_Page_Status EQ 10>
							<cfset Session.New_Sales_Page_Status = 0>	

						</cfif>

						<cfif Session.New_Sales_Page_Status EQ 20>
							<cfset Session.New_Sales_Page_Status = 0>	

						</cfif>
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
