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
						<li><a href="edit_sales.cfm" class="active">Edit Sale</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfset Session.Tax_Rate = 0.0775>

			<cfif Not IsDefined("Session.Edit_Sales_Item_Modal_Status")>
				<cfset Session.Edit_Sales_Item_Modal_Status = 0>				
			</cfif>

			<cfif IsDefined("form.edit_sales_step_1")>
				<cfset Session.Edit_Sales_Item_Modal_Status = 10>
			</cfif>	

			<cfif IsDefined("url.id1")>
				<cfset GoodData = 1>
				<cfset Session.Edit_Sales_Item_ID = Trim(url.id1)>
				<cfif IsDefined("url.id2")>
					<cfset Session.Edit_Sales_Inventory_ID = Trim(url.id2)>
					<cfquery name="get_sales" datasource="#DSN#">
						Select * from sales 
						where id = <cfqueryparam value="#Session.Edit_Sales_Item_ID#" cfsqltype="cf_sql_varchar">	
						and inventory_id = <cfqueryparam value="#Session.Edit_Sales_Inventory_ID#" cfsqltype="cf_sql_varchar" >	
					</cfquery>
				</cfif>

				<cfif get_sales.recordcount EQ 0>
					<cfset Session.Edit_Sales_Item_Modal_Status = 99>					
				</cfif>
			</cfif>

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_sales.cfm">Manage Sales</a></li>
							<li><a href="edit_sales.cfm" >Edit Sale</a></li>					      	
				      	</ol>
				    </div>				
					
					<div class="content-wrap">	

						<cfquery name="get_inventory" datasource="#DSN#">
							select i.*, lm.description, lm.type
							from inventory i
							inner join list_management lm
							on i.category_id = lm.id and lm.type = 'category'
							where i.id = <cfqueryparam value="#Session.Edit_Sales_Inventory_ID#" cfsqltype="cf_sql_varchar" >	
						</cfquery>

						<cfset Session.Max_QTY = get_inventory.on_hand_qty>
				
						<cfquery name="get_payment_method" datasource="#DSN#">
							select *
							from list_management
							where type = 'payment method'
							and active = '1'
							Order by description
						</cfquery>		

						<cfquery name="get_sales_location" datasource="#DSN#">
							select *
							from list_management
							where type = 'sales location'
							and active = '1'
							Order by description
						</cfquery>								

						<cfif Session.Edit_Sales_Item_Modal_Status EQ 0>
							<cfform method=post action="edit_sales.cfm">								
								<div class="content-wrap">
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Inventory:</strong>
										</div>
										<div class="col-sm-5">									
											#Trim(get_inventory.description)# (QTY: #Trim(get_inventory.on_hand_qty)#)
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>									
								</div>	
													
								<div class="content-wrap">

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">	
										<div class="col-sm-2">
											<strong>Sales Date:</strong>
										</div>		
										<div class="col-sm-5">
											<input name="sale_date" type="date" class="form-control" value="#DateFormat(get_sales.date_sold, "yyyy-mm-dd")#">
										</div>	
										<div class="col-sm-5">
											&nbsp;
										</div>																	
									</div>	
									
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Price Sold:</strong>
										</div>
										<div class="col-sm-5">									
											<cfinput name="price_sold" type="float" min="0" placeholder="Price Sold" value="#get_sales.sales_price#" class="form-control">
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>	

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Quantity Sold:</strong>
										</div>
										<div class="col-sm-5">									
											<cfinput name="quantity_sold" type="float" min="0" placeholder="Quantity Sold" value="#get_sales.qty_sold#" class="form-control">
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

																											
									<div class="row">
										<div class="col-sm-2">
											<strong>Tax :</strong>
										</div>
										<div class="col-sm-5">									
											<cfinput name="tax" type="float" min="0"  value="#get_sales.tax_rate#" class="form-control">
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	

									<div class="row">										
										<div class="col-sm-2">
											<strong>Collect Tax?</strong>
										</div>
									  	<div class="col-sm-3 switch-left">	
									  		<div class="d-flex">										  		
										  		No&nbsp;&nbsp;
										        <div class="form-switch form-switch form-switch-md">
										            <input class="form-check-input" type="checkbox" name="collect_tax" id="flexSwitchCheckChecked" value="1" <cfif get_sales.collect_tax EQ 1>checked</cfif>>  	
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
										<div class="col-sm-2">
											<strong>Payment Method:</strong>
										</div>
										<div class="col-sm-5">
											<cfselect name="payment_method" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_payment_method">
													<option value="#Trim(get_payment_method.id)#" <cfif get_payment_method.id EQ get_sales.payment_method>selected</cfif>>#Trim(get_payment_method.description)#</option>
												</cfloop>										
											</cfselect>
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Sales Location:</strong>
										</div>
										<div class="col-sm-5">
											<cfselect name="sales_location" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_sales_location">
													<option value="#Trim(get_sales_location.id)#" <cfif get_sales_location.id EQ get_sales.sales_location>selected</cfif>>#Trim(get_sales_location.description)#</option>
												</cfloop>										
											</cfselect>
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Sales Note:</strong>
										</div>
										<div class="col-sm-5">
											<cftextarea name="sales_note" cols="30" rows="5" placeholder="Add any notes about this sale here..." class="form-control">#get_sales.sales_note#</cftextarea>											
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>

									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>	
									<div class="row">
										<div class="col-sm-12">								
											<cfinput type="submit" name="edit_sales_step_1" value="Next" class="btn btn-primary">																														
										</div>			  								
									</div>								
								</div>	
							</cfform>
						</cfif>

						<cfif Session.Edit_Sales_Item_Modal_Status EQ 10>
							<cfset Session.Edit_Sales_Item_Modal_Status = 0>	

							<cfset Good_Sale = 1>

							<cfset Session.Price_Sold = Form.price_sold>
							<cfset Session.Quantity_Sold = Form.quantity_sold>
							<cfset Session.Tax_Rate = Form.tax>
							<cfset Session.Payment_Method = Form.payment_method>
							<cfset Session.Sales_Location = Form.sales_location>
							<cfset Session.Date_Sold = Form.sale_date>
							<cfset Session.collect_tax = 0>
							<cfset Session.Sales_Note = Trim(Form.sales_note)>

							<cfif IsDefined("form.collect_tax")>
								<cfset Session.collect_tax = 1>
							</cfif>

							<cfif Session.collect_tax EQ 0>
								<p>
									You have chosen not to collect tax on this sale. The tax rate you entered will be ignored and no tax will be collected on this sale.
								</p>
							<cfelse>
								<p>
									You have chosen to collect tax on this sale. The tax rate you entered will be applied to the sale and included in the total revenue calculation.
								</p>	
							</cfif>

							<cfif Session.quantity_sold GT Session.Max_QTY>
								<cfset Good_Sale = 0>
								<div class="alert alert-danger" role="alert">
									Quantity Sold cannot be greater than quantity on hand. Please adjust the quantity sold or update the inventory on hand quantity.	
								</div>
							<cfelse>
								<cfset Good_Sale = 1>
							</cfif>

							<cfif Good_Sale	>
								<!--- This is where we would display the sales details form and allow the user to submit the new sale to the database. --->
								<cfquery name="get_sales_info" datasource="#DSN#">
									select i.*, lm.description, lm.type
									from inventory i
									inner join list_management lm
									on i.category_id = lm.id and lm.type = 'category'
									where i.id = <cfqueryparam value="#Session.New_Sales_Inventory_ID#" cfsqltype="cf_sql_longvarchar" >
								</cfquery>
								
								<cfif Session.collect_tax EQ 1>									
									<cfset Session.Tax_Amount = Session.Price_Sold * Session.Tax_Rate>								
									<cfset Session.Sub_Total_Revenue = Session.Price_Sold - Session.Tax_Amount>
									<cfset Session.Total_Cost = get_sales_info.plant_cost + get_sales_info.shipping_cost>
									<cfset Session.Total_Revenue = Session.Sub_Total_Revenue - Session.Total_Cost>
								<cfelse>
									<cfset Session.Tax_Amount = 0>
									<cfset Session.Tax_Rate = 0>
									<cfset Session.Sub_Total_Revenue = Session.Price_Sold>
									<cfset Session.Total_Cost = get_sales_info.plant_cost + get_sales_info.shipping_cost>
									<cfset Session.Total_Revenue = Session.Sub_Total_Revenue - Session.Total_Cost>
								</cfif>

								<cfset Session.sales_db_uuid = rereplace(createuuid(),"-","","all")>
								<cfquery name="update_sales" datasource="#DSN#">
									update sales
									set 
										date_sold = '#Session.Date_Sold#',
										qty_sold = '#Session.Quantity_Sold#',
										sales_price = '#Session.Price_Sold#',
										tax_rate = '#Session.Tax_Rate#',
										revenue = '#Session.Total_Revenue#',
										sales_location = '#Session.Sales_Location#',
										payment_method = '#Session.Payment_Method#',
										total_cost = '#Session.Total_Cost#',
										total_sales = '#Session.Sub_Total_Revenue#',
										collect_tax = '#Session.collect_tax#',
										sales_note = '#Session.Sales_Note#'
									where id = <cfqueryparam value="#Session.Edit_Sales_Item_ID#" cfsqltype="cf_sql_varchar">
								</cfquery>

								<div class="row">			
									<div class="col-sm-12">
										&nbsp;
									</div>																	
								</div>	

								<div class="alert alert-info" role="alert">
									Sales details updated! Please review the updated information below. If you need to make additional changes, click the Edit Sale button again to update the sale details.
								</div>

								<div class="row">			
									<div class="col-sm-12">
										&nbsp;
									</div>																	
								</div>
							<cfelse>
								<div class="row">			
									<div class="col-sm-12">
										&nbsp;
									</div>																	
								</div>	
								<div class="alert alert-danger" role="alert">
									There was an issue with the sale details you entered. Please review the information and try again.	
								</div>								
							</cfif>
						</cfif>

						<cfif Session.Edit_Sales_Item_Modal_Status EQ 99>
							<cfset Session.Edit_Sales_Item_Modal_Status = 0>
							<div class="row">			
								<div class="col-sm-12">
									&nbsp;
								</div>																	
							</div>	
							<div class="alert alert-danger" role="alert">
								Item not found. Please try again.	
							</div>	
						</cfif>
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>

		    <cfinclude template="common_footer.cfm" >

		    <cfinclude template="js.cfm" >

		  </body>
	</html>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
