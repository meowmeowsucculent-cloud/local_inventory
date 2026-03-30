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
						<li><a href="manage_inventory_loss.cfm" class="active">Manage Inventory Loss</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfset Session.Display_Filtered_Data = 1>
			<CFPARAM NAME = "Session.Has_Inventory_Loss" default="0">

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_inventory_loss.cfm">Manage Inventory Loss</a></li>					      	
				      	</ol>
				    </div>				
				
					<cfquery name="get_inventory_loss" datasource="#DSN#">
						select il.loss_date, il.qty_lost, lm.description, lmi.description as inventory_item
						from inventory_loss il
						inner join list_management lm
						on il.loss_code = lm.id and lm.type = 'Plant Loss'
						inner join inventory i
						on il.inventory_id = i.id
						inner join list_management lmi
						on i.category_id = lmi.id and lmi.type = 'Category'
					</cfquery>
					<cfif get_inventory_loss.recordcount GT 0>
						<cfset Session.Has_Inventory_Loss = 1>
					</cfif>
					
					<div class="content-wrap">
						<cfform action="manage_inventory.cfm" method="post" >
		          			<div class="row class_table_heading">
								<div class="col-lg-3">									
									<!----
									Fiscal Year: &nbsp;
									<cfselect name="filter_year_value" size="1" onChange="loadPage(this)" class="form-select" id="bootstrap-select-filter">
										<option value="manage_inventory.cfm?id=9">- Select -</option>		          						
										<cfloop query="get_FY">
											<option value="manage_inventory.cfm?id=#Trim(get_FY.id)#" <cfif Trim(get_FY.id) EQ Session.filter_year_manage_inventory>Selected</cfif>>#Trim(get_FY.planning_year)#</option>
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
	          				<cfif Session.Has_Inventory_Loss>
								<table class="styled_picker stripe" id="universal_list_3">
									<thead>											
										<th>
											<strong>Inventory Item</strong>
										</th>
										<th>
											<strong>Loss Date</strong>
										</th>
										<th>
											<strong>Qty Lost</strong>
										</th>
										<th>
											<strong>Description</strong>
										</th>																				
									</thead>										
									<tbody>
										<cfloop query="get_inventory_loss">
											
											<tr>
												<td>
													#get_inventory_loss.inventory_item#
												</td>
												<td>
													#DateFormat(get_inventory_loss.loss_date, "mm/dd/yyyy")#
												</td>
												<td>
													#get_inventory_loss.qty_lost#
												</td>
												<td>
													#get_inventory_loss.description#
												</td>																				
											</tr>
										</cfloop> 
									</tbody>
								</table>									
							<cfelse>
								<p>
									There is no inventory loss to display
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
			<div class="modal fade" id="add_new_inventory_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Add Inventory</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_add_inventory.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->

			<div class="modal fade" id="edit_inventory_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Edit Inventory</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_edit_inventory.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->		

			<div class="modal fade" id="inventory_loss_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Inventory Loss</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_inventory_loss.cfm" >
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
