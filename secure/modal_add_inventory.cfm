<cftry>

	<cfif Not IsDefined("Session.Add_Inventory_Modal_Status")>
		<cfset Session.Add_Inventory_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.add_inventory")>
		<cfset Session.Add_Inventory_Modal_Status = 10>
	</cfif>	

	<CFPARAM NAME = "Session.is_pre_inventory" default="0">
	<CFPARAM NAME = "Session.is_purchased" default="0">
	<CFPARAM NAME = "Session.is_propagated" default="0">
	<CFPARAM NAME = "Session.quantity" default="0">
	<CFPARAM NAME = "Session.cost" default="0">
	<CFPARAM NAME = "Session.shipping" default="0">

	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Add_Inventory_Modal_Status EQ 0>
						<cfset GoodData = 1>
												
						<cfif GoodData>		
							<cfquery name="get_category" datasource="#DSN#">
								select *
								from list_management
								where type = 'category'
								and active = '1'
							</cfquery>
							<cfform method=post action="modal_add_inventory.cfm">								
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
													<option value="#Trim(get_category.id)#">#Trim(get_category.description)#</option>
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
										            <input class="form-check-input" type="checkbox" name="is_pre_inventory" id="flexSwitchCheckChecked">  	
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
										            <input class="form-check-input" type="checkbox" name="is_purchased" id="flexSwitchCheckChecked">  	
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
										            <input class="form-check-input" type="checkbox" name="is_propagated" id="flexSwitchCheckChecked">  	
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
											<cfinput name="quantity" type="number" min="0" placeholder="Quantity" class="form-control">
										</div>																	
									</div>	

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-3">
											<strong>Cost:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="cost" type="float" min="0" placeholder="Cost" class="form-control">
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-3">
											<strong>Shipping:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="shipping" type="float" min="0" placeholder="Shipping" class="form-control">
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="add_inventory" value="Add Inventory" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_inventory_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_inventory_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Add_Inventory_Modal_Status EQ 10>										
						<cfset Session.Add_Inventory_Modal_Status = 0>

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

						<!--- Insert inventory --->
						<cfset Session.db_uuid = rereplace(createuuid(),"-","","all")>
						<cfquery name="insert_inventory" datasource="#DSN#">
							insert into inventory 
							(id, category_id, is_pre_inventory, is_purchased, is_propagated, on_hand_qty, plant_cost, shipping_cost, created_date)
							values 
							('#Session.db_uuid#', '#Session.category#', '#Session.is_pre_inventory#', '#Session.is_purchased#', '#Session.is_propagated#', '#Session.quantity#', '#Session.cost#', '#Session.shipping#','#Session.DateNow#')
						</cfquery>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Inventory Added!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_inventory_modal"  data-bs-dismiss="modal">
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
