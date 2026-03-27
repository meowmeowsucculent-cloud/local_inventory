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
						<li><a href="add_new_sales.cfm" class="active">Add New Sale</a></li>															
					</ul>
				</div>
			</nav>
		    
		    <cfinclude template="clear_data.cfm" >

			<cfif Not IsDefined("Session.New_Sales_Page_Status")>
				<cfset Session.New_Sales_Page_Status = 0>				
			</cfif>

			<cfif IsDefined("url.inventory_target")>
				<cfset Session.New_Sales_Page_Status = 10>
				<cfset Session.New_Sales_Inventory_ID = url.inventory_target>
			</cfif>

			<cfif IsDefined("Form.sales_step_1")>
				<cfset Session.New_Sales_Page_Status = 20>				
			</cfif>	

			<cfset Session.Tax_Rate = 0.0775>

			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_sales.cfm">Manage Sales</a></li>
							<li><a href="add_new_sales.cfm" class="active">Add New Sale</a></li>					      	
				      	</ol>
				    </div>				
					
					<div class="content-wrap">	

						<cfquery name="get_inventory" datasource="#DSN#">
							select i.*, lm.description, lm.type
							from inventory i
							inner join list_management lm
							on i.category_id = lm.id and lm.type = 'category'
							where lm.active = '1'
							and lm.type = 'category'
							and i.on_hand_qty > '0'
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
							Order by description
						</cfquery>

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

						<cfif Session.New_Sales_Page_Status EQ 0>
							<cfform method=post action="add_new_sales.cfm">								
								<div class="content-wrap">
									<div class="row">			
										<div class="col-sm-12">
											&nbsp;
										</div>																	
									</div>																			
									<div class="row">
										<div class="col-sm-2">
											<strong>Select Inventory:</strong>
										</div>
										<div class="col-sm-5">									
											<cfselect name="inventory" size="1" class="form-select" onChange="loadPage(this)" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_inventory">
													<option value="add_new_sales.cfm?inventory_target=#Trim(get_inventory.id)#">#Trim(get_inventory.description)#</option>
												</cfloop>										
											</cfselect>
										</div>		
										<div class="col-sm-5">
											&nbsp;
										</div>									
									</div>									
								</div>	
							</cfform>
						</cfif>

						<cfif Session.New_Sales_Page_Status EQ 10>
							<cfset Session.New_Sales_Page_Status = 0>	

							<cfform method=post action="add_new_sales.cfm">								
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
											<cfinput name="sale_date" type="date" class="form-control">
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
											<cfinput name="price_sold" type="float" min="0" placeholder="Price Sold" class="form-control">
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
											<cfinput name="quantity_sold" type="float" min="0" placeholder="Quantity Sold" class="form-control">
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
											<cfinput name="tax" type="float" min="0"  value="#Session.Tax_Rate#" class="form-control">
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
											<strong>Payment Method:</strong>
										</div>
										<div class="col-sm-5">
											<cfselect name="payment_method" size="1" class="form-select" id="bootstrap-select-filter">
												<option value="0">- Select -</option>
												<cfloop query="get_payment_method">
													<option value="#Trim(get_payment_method.id)#">#Trim(get_payment_method.description)#</option>
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
													<option value="#Trim(get_sales_location.id)#">#Trim(get_sales_location.description)#</option>
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
										<div class="col-sm-12">								
											<cfinput type="submit" name="sales_step_1" value="Next" class="btn btn-primary">																														
										</div>			  								
									</div>								
								</div>	
							</cfform>
						</cfif>

						<cfif Session.New_Sales_Page_Status EQ 20>
							<cfset Session.New_Sales_Page_Status = 0>	

							<cfset Session.Price_Sold = Form.price_sold>
							<cfset Session.Quantity_Sold = Form.quantity_sold>
							<cfset Session.Tax_Rate = Form.tax>
							<cfset Session.Payment_Method = Form.payment_method>
							<cfset Session.Sales_Location = Form.sales_location>
							<cfset Session.Date_Sold = Form.sale_date>



							<!--- This is where we would display the sales details form and allow the user to submit the new sale to the database. --->
							<cfquery name="get_sales_info" datasource="#DSN#">
								select i.*, lm.description, lm.type
								from inventory i
								inner join list_management lm
								on i.category_id = lm.id and lm.type = 'category'
								where i.id = <cfqueryparam value="#Session.New_Sales_Inventory_ID#" cfsqltype="cf_sql_longvarchar" >
							</cfquery>

							<cfset Session.Subtotal = Session.Price_Sold * Session.Quantity_Sold>
							<cfset Session.Tax_Amount = Session.Subtotal * Session.Tax_Rate>
							<cfset Session.Sub_Total_Revenue = Session.Subtotal + Session.Tax_Amount>

							<cfset Session.Total_Cost = get_sales_info.plant_cost + get_sales_info.shipping_cost>

							<cfset Session.Total_Revenue = Session.Sub_Total_Revenue - Session.Total_Cost>

							<cfset Session.sales_db_uuid = rereplace(createuuid(),"-","","all")>
							<cfquery name="save_sales" datasource="#DSN#">
								insert into sales (id, inventory_id, date_sold, qty_sold, sales_price, tax_rate, revenue, sales_location, payment_method, total_cost, total_sales)
								values ('#Session.sales_db_uuid#', '#Session.New_Sales_Inventory_ID#', '#Session.Date_Sold#', '#Session.Quantity_Sold#', '#Session.Price_Sold#', '#Session.Tax_Rate#', '#Session.Total_Revenue#', 
								'#Session.Sales_Location#', '#Session.Payment_Method#', '#Session.Total_Cost#', '#Session.Sub_Total_Revenue#')																	
							</cfquery>

							
								<p>You have selected to add a new sale for the following inventory item:</p>
								<h3>#Trim(get_inventory.description)#</h3>
								<p>Additional sales details form would go here.</p>

								<p>
								Session.Sales_Location: #Session.Sales_Location#<br>
								Session.Payment_Method: #Session.Payment_Method#<br>
								Plant Cost: #get_sales_info.plant_cost#<br>
								Shipping Cost: #get_sales_info.shipping_cost#<br>
								QTY Sold: #Session.Quantity_Sold#<br>
								Sales Price: #Session.Price_Sold#<br>
								Tax: #Session.Tax_Rate#<br>
								Total Revenue: #Session.Total_Revenue#
								</p>
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
