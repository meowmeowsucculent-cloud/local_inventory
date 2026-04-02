<cftry>

	<cfif Not IsDefined("Session.Add_List_Item_Modal_Status")>
		<cfset Session.Add_List_Item_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.add_item")>
		<cfset Session.Add_List_Item_Modal_Status = 10>
	</cfif>	

	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Add_List_Item_Modal_Status EQ 0>
						<cfset GoodData = 1>
												
						<cfif GoodData>		
							<cfquery name="get_type" datasource="#DSN#">
								select distinct type
								from list_management	
                                order by type asc							
							</cfquery>

							<cfform method=post action="modal_add_item.cfm">								
								<div class="content-wrap">

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
																		
									<div class="row">
										<div class="col-sm-3">
											<strong>Type:</strong>
										</div>
										<div class="col-sm-7">
											<cfselect name="type" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_type">
													<option value="#Trim(get_type.type)#">#Trim(get_type.type)#</option>
												</cfloop>										
											</cfselect>
										</div>		
										<div class="col-sm-2">
											&nbsp;
										</div>									
									</div>								
									
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																												

									<div class="row">	
										<div class="col-sm-3">
											<strong>Description:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="description" type="text" placeholder="Description" class="form-control">
										</div>																	
									</div>
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="add_item" value="Add Item" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_item_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_item_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Add_List_Item_Modal_Status EQ 10>										
						<cfset Session.Add_List_Item_Modal_Status = 0>
						
						<cfset Session.description = form.description>
						<cfset Session.type = form.type>
					
						<cfset Session.item_db_uuid = rereplace(createuuid(),"-","","all")>
						<cfquery name="insert_item" datasource="#DSN#">
							insert into list_management
							(id, type, description, active, created)
							values 
							('#Session.item_db_uuid#', '#Session.type#', '#Session.description#', 1, '#Session.DateNow#')
						</cfquery>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Item Added!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
                            <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_item_modal"  data-bs-dismiss="modal">
                                Close
                            </button>
                        </div>
						
					</cfif>
								
				</div>
			</div>
		</cfoutput>
		
		</cflayoutarea>
	</cflayout>

	

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">
	
	</cfcatch>
</cftry>
