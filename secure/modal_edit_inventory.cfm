<cftry>

	<cfif Not IsDefined("Session.Edit_Inventory_Modal_Status")>
		<cfset Session.Edit_Inventory_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.edit_inventory")>
		<cfset Session.Edit_Inventory_Modal_Status = 10>
	</cfif>	

	<CFPARAM NAME = "Session.Edit_Inventory_ID" default="0">

	<cfif IsDefined("url.id")>
		<cfset GoodData = 1>
		<cfset Session.Edit_Inventory_ID = Trim(url.id)>
		<cfquery name="get_inventory" datasource="#DSN#">
			select i.*, lm.description, lm.type
			from inventory i
			inner join list_management lm
			on i.category_id = lm.id and lm.type = 'category'
			where lm.active = '1'
			and lm.type = 'category'
			and i.id = <cfqueryparam value="#Session.Edit_Inventory_ID#" cfsqltype="cf_sql_longvarchar" >
		</cfquery>

		<cfif Get_Inventory.recordcount EQ 0>
			<cfset Session.Edit_Inventory_Modal_Status = 99>
		<cfelse>
			<cfset Session.is_pre_inventory = Get_Inventory.is_pre_inventory>	
			<cfset Session.is_purchased = Get_Inventory.is_purchased>
			<cfset Session.is_propagated = Get_Inventory.is_propagated>
			<cfset Session.quantity = Get_Inventory.on_hand_qty>
			<cfset Session.cost = Get_Inventory.plant_cost>	
			<cfset Session.shipping = Get_Inventory.shipping_cost>
			<cfset Session.category = Get_Inventory.category_id>
		</cfif>
	</cfif>

	<cfif Session.Edit_Inventory_ID EQ 0>
		<cfset Session.Edit_Inventory_Modal_Status = 99>		
	</cfif>	

	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Edit_Inventory_Modal_Status EQ 0>
						<cfset GoodData = 1>
												
						<cfif GoodData>		
							<cfquery name="get_category" datasource="#DSN#">
								select *
								from list_management
								where type = 'category'
								and active = '1'
							</cfquery>
							<cfform method=post action="modal_edit_inventory.cfm">								
								<div class="content-wrap">
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-3">
											<strong>Plant Category:</strong>
										</div>
										<div class="col-sm-7">
											<cfselect name="category" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_category">
													<option value="#Trim(get_category.id)#" <cfif Session.category EQ get_category.id>selected</cfif>>#Trim(get_category.description)#</option>
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
											<strong>Pre-Inventory?</strong>
										</div>
									  	<div class="col-sm-3 switch-left">	
									  		<div class="d-flex">										  		
										  		No&nbsp;&nbsp;
										        <div class="form-switch form-switch form-switch-md">
										            <input class="form-check-input" type="checkbox" name="is_pre_inventory" id="flexSwitchCheckChecked" <cfif Session.is_pre_inventory eq 1>checked</cfif>>    														
										        </div>
										        <label for="site_state" class="form-check-label">&nbsp;&nbsp;Yes</label>
									  		</div>									  						  	
								       	</div>	
								       	<div class="col-sm-6">
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
											<strong>Purchased?</strong>
										</div>
									  	<div class="col-sm-3 switch-left">	
									  		<div class="d-flex">										  		
										  		No&nbsp;&nbsp;
										        <div class="form-switch form-switch form-switch-md">
										            <input class="form-check-input" type="checkbox" name="is_purchased" id="flexSwitchCheckChecked" <cfif Session.is_purchased eq 1>checked</cfif>>  	
										        </div>
										        <label for="site_state" class="form-check-label">&nbsp;&nbsp;Yes</label>
									  		</div>									  						  	
								       	</div>	
								       	<div class="col-sm-6">
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
											<strong>Propagated?</strong>
										</div>
									  	<div class="col-sm-3 switch-left">	
									  		<div class="d-flex">										  		
										  		No&nbsp;&nbsp;
										        <div class="form-switch form-switch form-switch-md">
										            <input class="form-check-input" type="checkbox" name="is_propagated" id="flexSwitchCheckChecked" <cfif Session.is_propagated eq 1>checked</cfif>>  	
										        </div>
										        <label for="site_state" class="form-check-label">&nbsp;&nbsp;Yes</label>
									  		</div>									  						  	
								       	</div>	
								       	<div class="col-sm-6">
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
											<strong>Quantity:</strong>
										</div>
										<div class="col-sm-9">
											<cfinput name="quantity" type="number" min="0" class="form-control" value="#Session.quantity#">
										</div>																	
									</div>	

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-3">
											<strong>Cost Each:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="cost" type="float" min="0" class="form-control" value="#Session.cost#">
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-3">
											<strong>Shipping Each:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="shipping" type="float" min="0" class="form-control" value="#Session.shipping#">
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="edit_inventory" value="Submit Edits" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_inventory_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_inventory_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Edit_Inventory_Modal_Status EQ 10>										
						<cfset Session.Edit_Inventory_Modal_Status = 0>

						<cfset Session.is_pre_inventory = 0>	
						<cfset Session.is_purchased = 0>
						<cfset Session.is_propagated = 0>

						<cfif IsDefined("form.is_pre_inventory")>
							<cfset Session.is_pre_inventory = 1>
						</cfif>
						<cfif IsDefined("form.is_purchased")>
							<cfset Session.is_purchased = 1>
						</cfif>
						<cfif IsDefined("form.is_propagated")>
							<cfset Session.is_propagated = 1>
						</cfif>

						<cfset Session.quantity = Trim(form.quantity)>
						<cfset Session.cost = Trim(form.cost)>
						<cfset Session.shipping = Trim(form.shipping)>
						<cfset Session.category = Trim(form.category)>

						<!--- Update inventory --->
						
						<cfquery name="update_inventory" datasource="#DSN#">
							update inventory 
							set category_id = '#Session.category#', is_pre_inventory = '#Session.is_pre_inventory#', is_purchased = '#Session.is_purchased#', is_propagated = '#Session.is_propagated#', 
							on_hand_qty = '#Session.quantity#', plant_cost = '#Session.cost#', shipping_cost = '#Session.shipping#'
							where id = <cfqueryparam value="#Session.Edit_Inventory_ID#" cfsqltype="cf_sql_longvarchar" >
						</cfquery>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Edits have been submitted!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
							<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_inventory_modal"  data-bs-dismiss="modal">
								Close
							</button>
						</div>
						
					</cfif>

					<cfif Session.Edit_Inventory_Modal_Status EQ 99>
						<cfset Session.Edit_Inventory_Modal_Status = 0>
						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Data not found. Please try again.
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
							<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_inventory_modal"  data-bs-dismiss="modal">
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
