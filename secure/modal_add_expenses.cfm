<cftry>

	<cfif Not IsDefined("Session.Add_Expense_Modal_Status")>
		<cfset Session.Add_Expense_Modal_Status = 0>				
	</cfif>

	<cfif IsDefined("form.add_expense")>
		<cfset Session.Add_Expense_Modal_Status = 10>
	</cfif>	

	<CFPARAM NAME = "Session.have_receipt" default="0">


	<cflayout type="vbox" name="layout1">
		<cflayoutarea overflow="hidden" >
		<cfoutput >
			<div id="content">
				<div class="container-fluid">
						
					<cfif Session.Add_Expense_Modal_Status EQ 0>
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

							<cfform method=post action="modal_add_expenses.cfm">								
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
											<cfinput name="expense_date" type="date" class="form-control">
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
										<div class="col-sm-3">
											<strong>Amount:</strong>
										</div>		
										<div class="col-sm-9">
											<cfinput name="amount" type="float" min="0" placeholder="Amount" class="form-control">
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
											<cftextarea name="notes" cols="50" rows="5"></cftextarea>
										</div>																	
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="add_expense" value="Add Expense" class="btn btn-primary">
											
											<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_expense_modal"  data-bs-dismiss="modal">
												Cancel
											</button>								
										</div>			  								
									</div>
								</div>	
							</cfform>	  		
						<cfelse>
							<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_expense_modal"  data-bs-dismiss="modal">
									Close
								</button>
							</div>
						</cfif>				
					</cfif>

					<cfif Session.Add_Expense_Modal_Status EQ 10>										
						<cfset Session.Add_Expense_Modal_Status = 0>

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
						<cfquery name="insert_expense" datasource="#DSN#">
							insert into expense
							(id, expense_date, vendor_payee, category, description, payment_method, amount, receipt, notes)
							values 
							('#Session.expense_db_uuid#', '#Session.DateNow#', '#Session.vendor#', '#Session.category#', '#Session.description#', '#Session.payment_method#', '#Session.amount#', '#Session.have_receipt#', '#Session.notes#')
						</cfquery>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>	

						<div class="alert alert-info" role="alert">
							Expense Added!
						</div>

						<div class="row">			
							<div class="col-sm-12">
								&nbsp;
							</div>																	
						</div>

						<div class="content-wrap">							
								<button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##add_new_expense_modal"  data-bs-dismiss="modal">
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
