<cftry>

	<cfif Not IsDefined("Session.Edit_Expense_Modal_Status")>
		<cfset Session.Edit_Expense_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.edit_expense")>
		<cfset Session.Edit_Expense_Modal_Status = 10>
	</cfif>	

	<CFPARAM NAME = "Session.have_receipt" default="0">
	<CFPARAM NAME = "Session.Edit_Expense_ID" default="0">

	<cfif IsDefined("url.id")>
		<cfset GoodData = 1>
		<cfset Session.Edit_Expense_ID = Trim(url.id)>
		<cfquery name="get_expense" datasource="#DSN#">
			select e.id, e.expense_date, e.description as expense_desc, e.amount, e.receipt, e.notes, lme.description as payment_vendor, lmp.description as payment_method, e.inventory_id, lmc.description as expense_category
			from expense e
			inner join list_management lme
			on lme.id = e.vendor_payee and lme.type = 'Vendor'
			inner join list_management lmp
			on lmp.id = e.payment_method and lmp.type = 'Payment Method'
			inner join list_management lmc
			on lmc.id = e.category and lmc.type = 'Expense'
			where e.id = <cfqueryparam value="#Session.Edit_Expense_ID#" cfsqltype="cf_sql_longvarchar" >
		</cfquery>

		<cfif Get_Expense.recordcount EQ 0>
			<cfset Session.Edit_Expense_Modal_Status = 99>
		<cfelse>
			<cfset Session.expense_date = DateFormat(get_expense.expense_date, "YYYY-MM-DD")>
			<cfset Session.category = get_expense.expense_category>	
			<cfset Session.vendor = get_expense.payment_vendor>
			<cfset Session.payment_method = get_expense.payment_method>
			<cfset Session.description = get_expense.expense_desc>
			<cfset Session.amount = get_expense.amount>
			<cfset Session.notes = get_expense.notes>
			<cfset Session.have_receipt = get_expense.receipt>			
		</cfif>
	</cfif>


	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Edit_Expense_Modal_Status EQ 0>
						<cfset GoodData = 1>
												
						<cfif GoodData>		
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
								Order by description
							</cfquery>

							<cfquery name="get_payment_method" datasource="#DSN#">
								select *
								from list_management
								where type = 'payment method'
								and active = '1'
								Order by description
							</cfquery>

							<cfform method=post action="modal_edit_expenses.cfm">								
								<div class="content-wrap">

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-3">
											<strong>Expense Date:</strong>
										</div>		
										<div class="col-sm-9">
											<input name="expense_date" type="date" class="form-control" value="#DateFormat(get_expense.expense_date, "yyyy-mm-dd")#">
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
											<cfselect name="category" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_expense_category">
													<option value="#Trim(get_expense_category.id)#" <cfif Session.category EQ #Trim(get_expense_category.description)#>selected</cfif>>#Trim(get_expense_category.description)#</option>
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
													<option value="#Trim(get_vendor.id)#" <cfif Session.vendor EQ #Trim(get_vendor.description)#>selected</cfif>>#Trim(get_vendor.description)#</option>
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
													<option value="#Trim(get_payment_method.id)#" <cfif Session.payment_method EQ #Trim(get_payment_method.description)#>selected</cfif>>#Trim(get_payment_method.description)#</option>
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
										            <input class="form-check-input" type="checkbox" name="have_receipt" id="flexSwitchCheckChecked" <cfif Session.have_receipt EQ 1>checked</cfif>>  	
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
											<strong>Description:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="description" type="text" placeholder="Description" class="form-control" value="#Session.description#">
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-3">
											<strong>Amount:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="amount" type="float" min="0" placeholder="Amount" class="form-control" value="#Session.amount#">
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
											<cftextarea name="notes" cols="50" rows="5" class="form-control">#Session.notes#</cftextarea>
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="edit_expense" value="Save Changes" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_expenses_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_expenses_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Edit_Expense_Modal_Status EQ 10>										
						<cfset Session.Edit_Expense_Modal_Status = 0>

						<cfif IsDefined("form.have_receipt")>
							<cfset Session.have_receipt = 1>
						</cfif>

						<cfset Session.expense_date = form.expense_date>
						<cfset Session.category = form.category>
						<cfset Session.vendor = form.vendor>
						<cfset Session.payment_method = form.payment_method>
						<cfset Session.description = form.description>
						<cfset Session.amount = form.amount>
						<cfset Session.notes = Trim(form.notes)>
					
						<cfset Session.expense_db_uuid = rereplace(createuuid(),"-","","all")>
						<cfquery name="update_expense" datasource="#DSN#">
							update expense
							set expense_date = '#Session.expense_date#',
							vendor_payee = '#Session.vendor#',
							category = '#Session.category#',	
							description = '#Session.description#',
							payment_method = '#Session.payment_method#',	
							amount = '#Session.amount#',
							receipt = '#Session.have_receipt#',	
							notes = '#Session.notes#'
							where id = <cfqueryparam value="#Session.Edit_Expense_ID#" cfsqltype="cf_sql_longvarchar" >
						</cfquery>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Expense Updated!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
							<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##edit_expenses_modal"  data-bs-dismiss="modal">
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
