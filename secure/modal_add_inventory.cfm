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
	<CFPARAM NAME = "Session.have_receipt" default="0">
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
							<cfquery name="get_plant_category" datasource="#DSN#">
								select *
								from list_management
								where type = 'category'
								and active = '1'
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
							</cfquery>

							<cfquery name="get_payment_method" datasource="#DSN#">
								select *
								from list_management
								where type = 'payment method'
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
											<cfselect name="plant_category" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_plant_category">
													<option value="#Trim(get_plant_category.id)#">#Trim(get_plant_category.description)#</option>
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
											<strong>Vendor/Payee:</strong>
										</div>
										<div class="col-sm-7">
											<cfselect name="vendor" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_vendor">
													<option value="#Trim(get_vendor.id)#">#Trim(get_vendor.description)#</option>
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
											<strong>Expense Category:</strong>
										</div>
										<div class="col-sm-7">
											<cfselect name="expense_category" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_expense_category">
													<option value="#Trim(get_expense_category.id)#">#Trim(get_expense_category.description)#</option>
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
											<strong>Payment Method:</strong>
										</div>
										<div class="col-sm-7">
											<cfselect name="payment_method" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_payment_method">
													<option value="#Trim(get_payment_method.id)#">#Trim(get_payment_method.description)#</option>
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
											<strong>Have Receipt?</strong>
										</div>
									  	<div class="col-sm-3 switch-left">	
									  		<div class="d-flex">										  		
										  		No&nbsp;&nbsp;
										        <div class="form-switch form-switch form-switch-md">
										            <input class="form-check-input" type="checkbox" name="have_receipt" id="flexSwitchCheckChecked">  	
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
											<strong>Cost Each:</strong>
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
											<strong>Shipping Each:</strong>
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
										<div class="col-sm-3">
											<strong>Notes:</strong>
										</div>		
										<div class="col-sm-9">
											<cftextarea name="notes" cols="50" rows="5" class="form-control"></cftextarea>
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
						<cfif IsDefined("form.have_receipt")>
							<cfset Session.have_receipt = 1>
						</cfif>

						<cfset Session.quantity = Trim(form.quantity)>
						<cfset Session.cost = Trim(form.cost)>
						<cfset Session.shipping = Trim(form.shipping)>
						<cfset Session.plant_category = Trim(form.plant_category)>
						<cfset Session.notes = Trim(form.notes)>
						<cfset Session.vendor = Trim(form.vendor)>
						<cfset Session.payment_method = Trim(form.payment_method)>
						<cfset Session.expense_category = Trim(form.expense_category)>
						<cfset Session.Total_Cost = Session.cost + Session.shipping>	

						<!--- Insert inventory --->
						<cfset Session.inventory_db_uuid = rereplace(createuuid(),"-","","all")>
						<cfquery name="insert_inventory" datasource="#DSN#">
							insert into inventory 
							(id, category_id, is_pre_inventory, is_purchased, is_propagated, on_hand_qty, plant_cost, shipping_cost, created_date, notes)
							values 
							('#Session.inventory_db_uuid#', '#Session.plant_category#', '#Session.is_pre_inventory#', '#Session.is_purchased#', '#Session.is_propagated#', '#Session.quantity#', '#Session.cost#', '#Session.shipping#','#Session.DateNow#', '#Session.notes#')
						</cfquery>

						<cfset Session.expense_db_uuid = rereplace(createuuid(),"-","","all")>
						<cfquery name="insert_expense" datasource="#DSN#">
							insert into expense
							(id, expense_date, vendor_payee, category, description, payment_method, amount, receipt, notes, inventory_id)
							values 
							('#Session.expense_db_uuid#', '#Session.DateNow#', '#Session.vendor#', '#Session.expense_category#', 'Inventory Addition', '#Session.payment_method#', '#Session.Total_Cost#', '#Session.have_receipt#', '#Session.notes#', '#Session.inventory_db_uuid#')
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
