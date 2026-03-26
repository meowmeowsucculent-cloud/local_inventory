<cftry>

	<cfif Not IsDefined("Session.Edit_Inventory_Loss_Modal_Status")>
		<cfset Session.Edit_Inventory_Loss_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.edit_inventory")>
		<cfset Session.Edit_Inventory_Loss_Modal_Status = 10>
	</cfif>	

	<CFPARAM NAME = "Session.Edit_Inventory_Loss_ID" default="0">
	<CFPARAM NAME = "Session.Current_Quantity" default="0">

	<cfif IsDefined("url.id")>
		<cfset GoodData = 1>
		<cfset Session.Edit_Inventory_Loss_ID = Trim(url.id)>

		<cfquery name="get_inventory" datasource="#DSN#">
			select i.*, lm.description, lm.type
			from inventory i
			inner join list_management lm
			on i.category_id = lm.id and lm.type = 'category'
			where lm.active = '1'
			and lm.type = 'category'
			and i.id = <cfqueryparam value="#Session.Edit_Inventory_Loss_ID#" cfsqltype="cf_sql_longvarchar" >
		</cfquery>

		<cfif Get_Inventory.recordcount EQ 0>		
			<cfset Session.Edit_Inventory_Loss_Modal_Status = 99>
		<cfelse>
			<cfset Session.Current_Quantity = get_inventory.on_hand_qty>
		</cfif>
	</cfif>

	<cfif Session.Edit_Inventory_Loss_ID EQ 0>
		<cfset Session.Edit_Inventory_Loss_Modal_Status = 99>		
	</cfif>	

	<cfif Session.Current_Quantity EQ 0>
		<cfset Session.Edit_Inventory_Loss_Modal_Status = 98>		
	</cfif>	

	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Edit_Inventory_Loss_Modal_Status EQ 0>
						<cfset GoodData = 1>
												
						<cfif GoodData>		
							<cfquery name="get_loss_reason" datasource="#DSN#">
								select *
								from list_management
								where type = 'Plant Loss'
								and active = '1'
								order by description
							</cfquery>
							<cfform method=post action="modal_inventory_loss.cfm">								
								<div class="content-wrap">
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>		

									<div class="row">			
										<div class="col-sm-12">
											<strong>Inventory Item:</strong> #get_inventory.description#
										</div>																	
									</div>	

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
															
									<div class="row">
										<div class="col-sm-3">
											<strong>Inventory Loss Reason:</strong>
										</div>
										<div class="col-sm-7">
											<cfselect name="inventory_loss_reason" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_loss_reason">
													<option value="#Trim(get_loss_reason.id)#">#Trim(get_loss_reason.description)#</option>
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
											<strong>Quantity Lost:</strong>
										</div>
										<div class="col-sm-9">
											<cfinput name="quantity" type="number" min="0" class="form-control">
										</div>																	
									</div>	

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="edit_inventory" value="Submit Loss" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##inventory_loss_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##inventory_loss_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Edit_Inventory_Loss_Modal_Status EQ 10>										
						<cfset Session.Edit_Inventory_Loss_Modal_Status = 0>

						<cfset Session.quantity = Trim(form.quantity)>						
						<cfset Session.inventory_loss_reason = Trim(form.inventory_loss_reason)>

						<!--- Update inventory --->
						<cfset Session.db_uuid = rereplace(createuuid(),"-","","all")>
						<cfquery name="save_loss" datasource="#dsn#">
							insert into inventory_loss (id, inventory_id, loss_code, loss_date, qty_lost)
							values ('#Session.db_uuid#', '#Session.Edit_Inventory_Loss_ID#', '#Session.inventory_loss_reason#', '#Session.DateNow#', '#Session.quantity#')
						</cfquery>

						<cfset Session.New_Quantity = Session.Current_Quantity - Session.quantity>

						<cfquery name="update_inventory" datasource="#DSN#">
							update inventory 
							set on_hand_qty = '#Session.New_Quantity#'
							where id = <cfqueryparam value="#Session.Edit_Inventory_Loss_ID#" cfsqltype="cf_sql_longvarchar" >
						</cfquery>
						
						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Inventory loss submitted!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
							<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##inventory_loss_modal"  data-bs-dismiss="modal">
								Close
							</button>
						</div>
						
					</cfif>

					<cfif Session.Edit_Inventory_Loss_Modal_Status EQ 99>
						<cfset Session.Edit_Inventory_Loss_Modal_Status = 0>
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
							<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##inventory_loss_modal"  data-bs-dismiss="modal">
								Close
							</button>
						</div>
					</cfif>

					<cfif Session.Edit_Inventory_Loss_Modal_Status EQ 98>
						<cfset Session.Edit_Inventory_Loss_Modal_Status = 0>
						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							This inventory item has a quantity of 0. Please adjust the quantity on hand before submitting an inventory loss.
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
							<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##inventory_loss_modal"  data-bs-dismiss="modal">
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
