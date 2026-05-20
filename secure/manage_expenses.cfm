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
						<li><a href="manage_expenses.cfm" class="active">Manage Expenses</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfset Session.Display_Filtered_Data = 1>
			<CFPARAM NAME = "Session.Has_Expenses" default="0">

			<cfif Not IsDefined("Session.filter_expense_type")>
				<cfset Session.filter_expense_type = 0>
			</cfif>

			<cfif IsDefined("url.type_id")>
				<cfset Session.filter_expense_type = url.type_id>	
			</cfif>

			<cfif Not IsDefined("Session.filter_expense_vendor")>
				<cfset Session.filter_expense_vendor = 0>
			</cfif>

			<cfif IsDefined("url.type_vendor_id")>
				<cfset Session.filter_expense_vendor = url.type_vendor_id>	
			</cfif>

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_expenses.cfm">Manage Expenses</a></li>					      	
				      	</ol>
				    </div>				

					<div class="float-end mb-5">
						<a href="" data-bs-toggle="modal" data-bs-target="##add_new_expense_modal" data-backdrop="static"  style="text-decoration:none;">
							<button class="btn btn-primary" data-bs-toggle="tooltip" data-placement="bottom" title="Add Expenses">
								Add Expenses
							</button>
						</a>
					</div>	
				
					<cfquery name="get_expenses" datasource="#DSN#">
						select e.id, e.expense_date, e.description as expense_desc, e.amount, e.receipt, e.notes, lme.description as payment_vendor, lmp.description as payment_method, e.inventory_id, lmc.description as expense_category
						from expense e
						inner join list_management lme
						on lme.id = e.vendor_payee and lme.type = 'Vendor'
						inner join list_management lmp
						on lmp.id = e.payment_method and lmp.type = 'Payment Method'
						inner join list_management lmc
						on lmc.id = e.category and lmc.type = 'Expense'
						<cfif Session.filter_expense_type NEQ 0>
							where lmc.description = <cfqueryparam value="#Session.filter_expense_type#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif Session.filter_expense_vendor NEQ 0>
							where lme.description = <cfqueryparam value="#Session.filter_expense_vendor#" cfsqltype="cf_sql_varchar">
						</cfif>
						order by e.expense_date desc
					</cfquery>
					<cfif get_Expenses.recordcount GT 0>
						<cfset Session.Has_Expenses = 1>
					</cfif>

					<cfquery name="get_filter_type" datasource="#DSN#">
						select distinct lm.description
						from expense e
						inner join list_management lm
						on e.category = lm.id
						order by lm.description asc
					</cfquery>

					<cfquery name="get_filter_vendor" datasource="#DSN#">
						select distinct lm.description
						from expense e
						inner join list_management lm
						on e.vendor_payee = lm.id
						order by lm.description asc
					</cfquery>
					
					<div class="content-wrap">
						<cfform action="manage_expenses.cfm" method="post" >
		          			<div class="row class_table_heading">
								<div class="col-lg-3">
									Expense Type: &nbsp;									
									<cfselect name="filter_type_value" size="1" onChange="loadPage(this)" class="form-select" id="bootstrap-select-filter">
										<option value="manage_expenses.cfm?type_id=9">- Select -</option>		          						
										<option value="manage_expenses.cfm?type_id=0">- All -</option>	
										<cfloop query="get_filter_type">
											<option value="manage_expenses.cfm?type_id=#Trim(get_filter_type.description)#" <cfif Trim(get_filter_type.description) EQ Session.filter_expense_type>Selected</cfif>>#Trim(get_filter_type.description)#</option>
										</cfloop> 
									</cfselect>	
								</div>																
								
								<div class="col-lg-3">
									Vendor: &nbsp;									
									<cfselect name="filter_type_vendor" size="1" onChange="loadPage(this)" class="form-select" id="bootstrap-select-filter">
										<option value="manage_expenses.cfm?type_vendor_id=9">- Select -</option>		          						
										<option value="manage_expenses.cfm?type_vendor_id=0">- All -</option>	
										<cfloop query="get_filter_vendor">
											<option value="manage_expenses.cfm?type_vendor_id=#Trim(get_filter_vendor.description)#" <cfif Trim(get_filter_vendor.description) EQ Session.filter_expense_vendor>Selected</cfif>>#Trim(get_filter_vendor.description)#</option>
										</cfloop> 
									</cfselect>	
								</div>
								<div class="col-lg-6 data_align_left">
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
	          				<cfif Session.Has_Expenses>
								<table class="styled_picker stripe" id="universal_list_3">
									<thead>											
										<th>
											<strong>Expense Date</strong>
										</th>
										<th>
											<strong>Category</strong>
										</th>
										<th>
											<strong>Description</strong>
										</th>
										<th>
											<strong>Amount</strong>
										</th>
										<th>
											<strong>Vendor</strong>
										</th>
										<th>
											<strong>Payment Method</strong>
										</th>
										<th>
											<strong>Receipt</strong>
										</th>
										<th>
											<strong>Inventory Item</strong>
										</th>																																																				
										<th>
											<strong>Action</strong>
										</th>											
									</thead>										
									<tbody>
										<cfloop query="get_Expenses">
											
											<tr>
												<td>
													#DateFormat(get_Expenses.expense_date, "mm/dd/yyyy")#
												</td>
												<td>
													#get_Expenses.expense_category#
												</td>
												<td>
													#get_Expenses.expense_desc#												
												</td>
												<td>
													#DollarFormat(get_Expenses.amount)#
												</td>
												<td>
													#get_Expenses.payment_vendor#
												</td>
												<td>
													#get_Expenses.payment_method#
												</td>	
												<td>
													<cfif get_Expenses.receipt EQ 1>
														Yes
													<cfelse>
														No
													</cfif>
												<td>
													<cfif get_Expenses.inventory_id NEQ "">
														<cfquery name="get_Inventory_Item" datasource="#DSN#">
															select lm.description, lm.type
															from inventory i
															inner join list_management lm
															on i.category_id = lm.id and lm.type = 'category'
															where i.id = <cfqueryparam value="#get_expenses.inventory_id#" cfsqltype="cf_sql_longvarchar" >
														</cfquery>
														#Trim(get_Inventory_Item.description)#
													<cfelse>
														&nbsp;
													</cfif>
												</td>	
																				
												<td>																															
													<a class="action-icon" href="" data-bs-toggle="modal" data-bs-target="##edit_expenses_modal"  data-backdrop="static" data-remote="modal_edit_expenses.cfm?ID=#get_expenses.ID#" style="text-decoration:none;">
														<i class="bi bi-pencil-square" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Edit Item" aria-label="Edit Item">
														</i>
													</a>													                        					                      
												</td>
											</tr>
										</cfloop> 
									</tbody>
								</table>
							<cfelse>
								<p>
									There is no Expenses to display
								</p>
							</cfif>
						<cfelse>
							<p>
								There is no Expenses to display
							</p>
						</cfif>	
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>
		    
		    <!--- Modal --->
			<div class="modal fade" id="add_new_expense_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Add Expenses</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_add_expenses.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->

			<div class="modal fade" id="edit_expenses_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Edit Expenses</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_edit_expenses.cfm" >
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
