<cftry>

	<cfif Not IsDefined("Session.Edit_List_Item_Modal_Status")>
		<cfset Session.Edit_List_Item_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.edit_item")>
		<cfset Session.Edit_List_Item_Modal_Status = 10>
	</cfif>	

    <cfif IsDefined("url.id")>
		<cfset GoodData = 1>
		<cfset Session.Edit_Item_ID = Trim(url.id)>
		<cfquery name="get_items" datasource="#DSN#">
            select * from list_management
            where id = <cfqueryparam value="#Session.Edit_Item_ID#" cfsqltype="cf_sql_varchar">            
            order by type, description
        </cfquery>

		<cfif get_items.recordcount EQ 0>
			<cfset Session.Edit_List_Item_Modal_Status = 99>
		<cfelse>			
			<cfset Session.description = get_items.description>
            <cfset Session.type = get_items.type>					
		</cfif>
	</cfif>



	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Edit_List_Item_Modal_Status EQ 0>
						<cfset GoodData = 1>
												
						<cfif GoodData>		
							<cfquery name="get_type" datasource="#DSN#">
								select distinct type
								from list_management	
                                order by type asc							
							</cfquery>

							<cfform method=post action="modal_edit_item.cfm">								
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
													<option value="#Trim(get_type.type)#" <cfif Session.type EQ Trim(get_type.type)> selected</cfif>>#Trim(get_type.type)#</option>
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
											<cfinput name="description" type="text" value="#Session.description#" class="form-control">
										</div>																	
									</div>
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="edit_item" value="Save Changes" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_item_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_item_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Edit_List_Item_Modal_Status EQ 10>										
						<cfset Session.Edit_List_Item_Modal_Status = 0>
						
						<cfset Session.description = form.description>
						<cfset Session.type = form.type>
										
						<cfquery name="update_item" datasource="#DSN#">
							update list_management
							set type = '#Session.type#', description = '#Session.description#'
							where id = <cfqueryparam value="#Session.Edit_Item_ID#" cfsqltype="cf_sql_varchar">  
						</cfquery>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Item Updated!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
                            <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_item_modal"  data-bs-dismiss="modal">
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
