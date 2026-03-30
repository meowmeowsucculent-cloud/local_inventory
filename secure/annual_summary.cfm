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
						<li><a href="annual_summary.cfm" class="active">Annual Summary</a></li>															
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
				      		<li><a href="annual_summary.cfm">Annual Summary</a></li>					      	
				      	</ol>
				    </div>				

					<div class="content-wrap">
						<cfform action="annual_summary.cfm" method="post" >
		          			<div class="row class_table_heading">
								<div class="col-lg-3">									
									<!----
									Fiscal Year: &nbsp;
									<cfselect name="filter_year_value" size="1" onChange="loadPage(this)" class="form-select" id="bootstrap-select-filter">
										<option value="an.cfm?id=9">- Select -</option>		          						
										<cfloop query="get_FY">
											<option value="annual_summary.cfm?id=#Trim(get_FY.id)#" <cfif Trim(get_FY.id) EQ Session.filter_year_manage_sales>Selected</cfif>>#Trim(get_FY.planning_year)#</option>
										</cfloop> 
									</cfselect>
									--->
								</div>																
								<div class="col-lg-9 data_align_left">
								</div>
							</div>	
							<div class="row">
								<div class="col-lg-12">
									&nbsp;
								</div>
							</div>	 
							<div class="row">
								<div class="col-lg-12">
									&nbsp;
								</div>
							</div>	         				 		          				
	          			</cfform>

						<cfquery name="get_expenses" datasource="#DSN#">
							select sum(e.amount) as total_expense
							from expense e
							inner join list_management lme
							on lme.id = e.vendor_payee and lme.type = 'Vendor'
							inner join list_management lmp
							on lmp.id = e.payment_method and lmp.type = 'Payment Method'
							inner join list_management lmc
							on lmc.id = e.category and lmc.type = 'Expense'							
						</cfquery>

						<cfif Len(get_expenses.total_expense) EQ 0>
							<cfset Session.total_expense = 0>
						<cfelse>	
							<cfset Session.total_expense = get_expenses.total_expense>
						</cfif>

						<cfquery name="get_sales" datasource="#DSN#">
							select sum(s.sales_price) as total_sales
							from sales s
							inner join inventory i
							on s.inventory_id = i.id
							inner join list_management lmi
							on i.category_id = lmi.id and lmi.type = 'category'
							inner join list_management lmsl
							on s.sales_location = lmsl.id and lmsl.type = 'Sales Location'
							inner join list_management lmpm
							on s.payment_method = lmpm.id and lmpm.type = 'Payment Method'					
						</cfquery>
					
						<cfif Len(get_sales.total_sales) EQ 0>
							<cfset Session.total_sales = 0>
						<cfelse>
							<cfset Session.total_sales = get_sales.total_sales>
						</cfif>	

	          			
	          			<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Expenses Summary
						</div>

						<div class="row">			
							<div class="col-sm-12">
								Total Expenses: <strong>$#NumberFormat(Session.total_expense, "9,999.99")#</strong>
							</div>																	
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Sales Summary
						</div>

						<div class="row">			
							<div class="col-sm-12">
								Total Sales: <strong>$#NumberFormat(Session.total_sales, "9,999.99")#</strong>
							</div>																	
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							YTD Net Income
						</div>

						<div class="row">			
							<div class="col-sm-12">
								Net Income: <strong>$#NumberFormat(Session.total_sales - Session.total_expense, "9,999.99")#</strong>
							</div>																	
						</div>
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>
		    
		    <!--- Modal --->


		    <cfinclude template="common_footer.cfm" >

		    <cfinclude template="js.cfm" >

		  </body>
	</html>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
