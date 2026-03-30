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
						<li><a href="manage_sales.cfm" class="active">Manage Sales</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfset Session.Display_Filtered_Data = 1>

			<CFPARAM NAME = "Session.Has_Sales" default="0">

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_sales.cfm">Manage Sales</a></li>					      	
				      	</ol>
				    </div>				

					<div class="float-end mb-5">
						<a href="add_new_sales.cfm" style="text-decoration:none;">
							<button class="btn btn-primary" data-bs-toggle="tooltip" data-placement="bottom" title="Add Sales">
								Add Sales
							</button>
						</a>
					</div>	
				
					<cfquery name="get_sales" datasource="#DSN#">
						select s.id, s.date_sold, s.qty_sold, sales_price, s.tax_rate, s.revenue, lmi.description, lmsl.description as sales_location, lmpm.description as payment_method
						from sales s
						inner join inventory i
						on s.inventory_id = i.id
						inner join list_management lmi
						on i.category_id = lmi.id and lmi.type = 'category'
						inner join list_management lmsl
						on s.sales_location = lmsl.id and lmsl.type = 'Sales Location'
						inner join list_management lmpm
						on s.payment_method = lmpm.id and lmpm.type = 'Payment Method'
						order by s.date_sold desc
					</cfquery>
					<cfif get_sales.recordcount GT 0>
						<cfset Session.Has_Sales = 1>
					</cfif>
					
					<div class="content-wrap">
						<cfform action="manage_sales.cfm" method="post" >
		          			<div class="row class_table_heading">
								<div class="col-lg-3">									
									<!----
									Fiscal Year: &nbsp;
									<cfselect name="filter_year_value" size="1" onChange="loadPage(this)" class="form-select" id="bootstrap-select-filter">
										<option value="manage_sales.cfm?id=9">- Select -</option>		          						
										<cfloop query="get_FY">
											<option value="manage_sales.cfm?id=#Trim(get_FY.id)#" <cfif Trim(get_FY.id) EQ Session.filter_year_manage_sales>Selected</cfif>>#Trim(get_FY.planning_year)#</option>
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
	          			
	          			<cfif Session.Display_Filtered_Data>
	          				<cfif Session.Has_Sales>
								<table class="styled_picker stripe" id="universal_list_3">
									<thead>											
										<th>
											<strong>Date Sold</strong>
										</th>
										<th>
											<strong>Description</strong>
										</th>
										<th>
											<strong>Sales Location</strong>
										</th>
										<th>
											<strong>Payment Method</strong>
										</th>
										<th>
											<strong>Quantity Sold</strong>
										</th>
										<th>
											<strong>Sales Price</strong>
										</th>
										<th>
											<strong>Tax Rate</strong>
										</th>
										<th>
											<strong>Revenue</strong>
										</th>																																																		
										<th>
											<strong>Action</strong>
										</th>											
									</thead>										
									<tbody>
										<cfloop query="get_sales">
											
											<tr>
												<td>
													#DateFormat(get_sales.date_sold, "mm/dd/yyyy")#
												</td>
												<td>
													#get_sales.description#
												</td>
												<td>
													#get_sales.sales_location#
												</td>	
												<td>
													#get_sales.payment_method#
												</td>
												<td>
													#get_sales.qty_sold#
												</td>
												<td>
													#DollarFormat(get_sales.sales_price)#
												</td>
												<td>
													#get_sales.tax_rate# %
												</td>
												<td>
													#DollarFormat(get_sales.revenue)#
												</td>																															
												<td>																															
													<a class="action-icon" href="" data-bs-toggle="modal" data-bs-target="##edit_sales_modal"  data-backdrop="static" data-remote="modal_edit_sales.cfm?ID=#get_sales.ID#" style="text-decoration:none;">
														<i class="bi bi-pencil-square" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Edit Sale" aria-label="Edit Sale">
														</i>
													</a>														                        					                      
												</td>
											</tr>
										</cfloop> 
									</tbody>
								</table>
							<cfelse>
								<p>
									There is no inventory to display
								</p>
							</cfif>
						<cfelse>
							<p>
								There is no inventory to display
							</p>
						</cfif>	
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>
		    
		    <!--- Modal --->

			<div class="modal fade" id="edit_sales_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Edit Sales</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_edit_sales.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->		


		    <cfinclude template="common_footer.cfm" >

		    <cfinclude template="js.cfm" >

		  </body>
	</html>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
