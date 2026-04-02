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
						<li><a href="list_management.cfm" class="active">List Management</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="list_management.cfm">List Management</a></li>					      	
				      	</ol>
				    </div>				

					<div class="float-end mb-5">
						<a href="" data-bs-toggle="modal" data-bs-target="##add_new_item_modal" data-backdrop="static"  style="text-decoration:none;">
							<button class="btn btn-primary" data-bs-toggle="tooltip" data-placement="bottom" title="Add Item">
								Add Item
							</button>
						</a>
					</div>	
				
					<cfquery name="get_items" datasource="#DSN#">
						select * from list_management
						order by type, description
					</cfquery>
				
					<div class="content-wrap">
						<cfform action="list_management.cfm" method="post" >
		          			<div class="row class_table_heading">
								<div class="col-lg-3">									
									<!----
									Fiscal Year: &nbsp;
									<cfselect name="filter_year_value" size="1" onChange="loadPage(this)" class="form-select" id="bootstrap-select-filter">
										<option value="list_management.cfm?id=9">- Select -</option>		          						
										<cfloop query="get_FY">
											<option value="list_management.cfm?id=#Trim(get_FY.id)#" <cfif Trim(get_FY.id) EQ Session.filter_year_manage_inventory>Selected</cfif>>#Trim(get_FY.planning_year)#</option>
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
	          			
				
						<table class="styled_picker stripe" id="universal_list_3">
							<thead>											
								<th>
									<strong>Category</strong>
								</th>
								<th>
									<strong>Description</strong>
								</th>
								<th>
									<strong>Active</strong>
								</th>								
								<th>
									<strong>Date Added</strong>
								</th>																																									
								<th>
									<strong>Action</strong>
								</th>											
							</thead>										
							<tbody>
								<cfloop query="get_items">									
									<tr>
										<td>#get_items.type#</td>
										<td>#get_items.description#</td>	
										<td>
											<cfif get_items.active EQ 1>
												Yes
											<cfelse>
												No
											</cfif>
										</td>
										<td>#dateFormat(get_items.created, "mm/dd/yyyy")#</td>																	
										<td>																															
											<a class="action-icon" href="" data-bs-toggle="modal" data-bs-target="##edit_item_modal"  data-backdrop="static" data-remote="modal_edit_item.cfm?ID=#get_items.ID#" style="text-decoration:none;">
												<i class="bi bi-pencil-square" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Edit Item" aria-label="Edit Item">
												</i>
											</a>														                        					                      
										</td>
									</tr>
								</cfloop> 
							</tbody>
						</table>							
					
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>
		    
		    <!--- Modal --->
			<div class="modal fade" id="add_new_item_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Add Item</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_add_item.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->

			<div class="modal fade" id="edit_item_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Edit Item</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_edit_item.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->			


		    <cfinclude template="common_footer.cfm" >

		    <cfinclude template="js.cfm" >

			<!----
			<div class="row">
				<div class="col-lg-12">
				</div>
			</div>
			
			<div>
				<div class="alert alert-success">
				
				</div>
			</div>
			
			<cfqueryparam value="" cfsqltype="cf_sql_longvarchar" >		
			
			<cfqueryparam value="" cfsqltype="cf_sql_integer" >
			
					<cfqueryparam value="" cfsqltype="cf_sql_longvarchar" >		
			
			<cfqueryparam value="" cfsqltype="cf_sql_integer" >
			
			<cfset Session.Quality_Check_Field = Trim(ReReplaceNoCase(#Session.Quality_Check_Field#,"[^0-9a-zA-Z ]","","ALL"))>
			\w denotes [A-Za-z0-9_]
			email = ^[-\w.]+@[\w]+\.[\w]+$
			^[a-zA-Z0-9_\\.\\-]+@[a-zA-Z0-9_]+\\.[a-zA-Z0-9_]+$
			[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]
			
			Trim(ReReplaceNoCase(#Session.room_config_notes#,"[^0-9a-zA-Z_,\.\-\&]","","ALL"))>
			https://stackoverflow.com/questions/37010701/add-dash-to-java-regex

			Should solve your problem. In regex you need to escape anything that has meaning in the Regex engine (eg. -, ?, *, etc.).
			
			<cfset Session.room_config_notes = Trim(encodeForHTML(Session.room_config_notes))>
			
			<a class="action-icon" href="edit_request.cfm?type=software&mode=edit&Request_ID=#PendingLookUp.Request_ID#"  style="text-decoration:none;">
				<i class="bi bi-pencil-square" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Edit Request" aria-label="Edit Request">
				</i>
			</a>
			--->

		  </body>
	</html>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
