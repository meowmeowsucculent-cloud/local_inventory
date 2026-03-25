<cftry>
	<cfif Session.CRM_Interface_Manage_Inventory>
		
		<cfset Session.Current_Interface_Feature_Name = "SOM_CLIENT_REFRESH_MANAGE_ACCESS">
		<!DOCTYPE html>
		<html lang="en">
		  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1">

		    <title>School of Medicine - Client Refresh</title>

		  </head>

		  <body>

			<cfinclude template="page_header.cfm" >
			
			<nav class="subnav">
				<div class="container-fluid">
					<ul>			        		      				
						<li><a href="index.cfm">Home</a></li>	  
						<li><a href="manage_inventory.cfm">Manage New Inventory</a></li>
						<li><a href="manage_returns.cfm">Manage Returns</a></li>
						<li><a href="manage_ewaste.cfm" class="active">Manage eWaste</a></li>
						<li><a href="pending_approvals.cfm">Pending Approvals</a></li>		
						<li><a href="pickup_list.cfm" target="_blank" >Pickup List</a></li>	
						<li><a href="assigned_inventory.cfm">Assigned Systems</a></li>
						<li><a href="ewaste_search.cfm">Device Search</a></li>	
						<li><a href="metrics.cfm">Metrics</a></li>									
					</ul>					
				</div>						
			</nav>
			
			<cfif Session.CRM_Interface_Super_Admin>
				<nav class="adminnav">
					<div class="container-fluid">
						<cfinclude template="sub_menu.cfm" >
					</div>						
				</nav>
			</cfif>	
			
			

			<!----
		    <cfset Session.param_1 = Session.CurrentLogDate & " " & Session.CurrentLogTime>
		    <cfset Session.param_2 = "SOM_FED_ViewManageAccess">
		    <cfset Session.param_3 = "client_refresh">
		    <cfset Session.param_4 = session.cas_user_id>
		    <cfset Session.param_5 = Session.Server_Host_IP>
		    <cfset Session.param_6 = cgi.remote_addr>
		    <cfset Session.param_7 = "Manage Access">
		    <cfset Session.param_8 = "">
		    <cfset Session.param_9 = #session.cas_user_id#>
		    <cfset Session.param_10 = "">
		    <cfset Session.param_11 = "Manage Access page access">
		    <cfset Session.param_12 = "Manage Access page access">

		    <cfinclude template="record_audit_log.cfm" >
		    ---->
		    
			<cfinclude template="clear_data.cfm" >
			
			<cfoutput>
		    <div id="content">
		    	<div class="container-fluid">				
					<div class="page-header">
						
						<h2 class="page-title">Manage eWaste</h2>
						<button type="button" class="help-icon btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="##help_manage_access_Modal" >
							<i class="bi bi-question" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Help"></i>													
						</button>				      	

				      	<ol class="breadcrumbs">
				      		<li><a href="index.cfm">Home</a></li>					      		
				      		<li><a href="manage_ewaste.cfm">Manage eWaste</a></li>	
				      		<li><a href="ewaste_signoff.cfm">eWaste Sign-Off</a></li>				      		
				      		<li><a href="ewaste_history.cfm">eWaste History</a></li>				      							      
				      	</ol>
				    </div>	
				    
				    <div class="float-end mb-5">
						<a href="" data-bs-toggle="modal" data-bs-target="##add_old_device_modal" data-backdrop="static"  style="text-decoration:none;">
							<button class="btn btn-primary" data-bs-toggle="tooltip" data-placement="bottom" title="Add New User">
								Add Additional Device
							</button>
						</a>
					</div>	
				    
				    <cfif Not IsDefined("Session.Surplus_Page_Status")>
				    	<cfset Session.Surplus_Page_Status = 0>
				    </cfif>
				    
				    <cfif IsDefined("form.step_1")>
				    	<cfset Session.Surplus_Page_Status = 10>
				    </cfif>	
				    
				    <cfif IsDefined("form.step_2")>
				    	<cfset Session.Surplus_Page_Status = 20>
				    </cfif>		
				    
				    <cfif IsDefined("form.step_3")>
				    	<cfset Session.Surplus_Page_Status = 30>
				    </cfif>												

					<div class="content-wrap">
						
						<cfif Session.Surplus_Page_Status EQ 0>
				    		<cfset Session.Device_Array = ArrayNew(2)>
				    		<cfset GG = 1>
							
							<cfquery name="get_list" datasource="#DSN#">
								SELECT rds.*, 
								rne.serial_number,
								rne.recieved_by,
								rne.received_date,
								rne.available,
								rne.signed_out_to,
								rne.signed_out_by,
								rne.signout_approved_by,
								rne.date_signed_out,
								rne.date_signout_approved,
								rne.master_model_id, signed_out_to_name, signed_out_by_name,
								ditc.altiris_model, ew.device_counter, rds.form_factor
								FROM refresh_device_swap rds
								INNER JOIN dbo.refresh_new_equipment rne
								ON rds.new_equipment_id = rne.id
								INNER JOIN dbo.di_target_copy ditc
								ON rds.di_refresh_serial_number = ditc.fldSerialNumber
								INNER JOIN refresh_ewaste ew
								ON ew.device_swap_id = rds.id
								where rds.received_back = '1'
								AND rds.new_equipment_id <> 'ewaste_only'
								and rds.repurpose_internally = '0'
								and marked_for_surplus IS NULL
								AND 
								(ew.attest_person_1_signed IS NULL
								AND ew.attest_person_2_signed IS null
								)
							</cfquery>
							
							<cfloop query="get_list">
								<cfset Session.Device_Array[GG][1] = get_list.id>
								<cfset Session.Device_Array[GG][2] = get_list.di_refresh_serial_number>
								<cfset Session.Device_Array[GG][3] = get_list.date_received>
								<cfset Session.Device_Array[GG][4] = get_list.received_back_by_name>
								<cfset Session.Device_Array[GG][5] = get_list.person_returning_computer_name>
								<cfset Session.Device_Array[GG][6] = get_list.new_equipment_id>
								<cfset Session.Device_Array[GG][7] = get_list.altiris_model>
								<cfset Session.Device_Array[GG][8] = get_list.device_counter>
								<cfset Session.Device_Array[GG][9] = get_list.form_factor>
								<cfset GG = GG + 1>
							</cfloop>
							
							<cfquery name="get_list" datasource="#DSN#">
								SELECT rds.*, ditc.altiris_model, ditc.fldPCModel, ew.device_counter
								FROM refresh_device_swap rds	
								LEFT JOIN dbo.di_target_copy  ditc
								ON ditc.fldSerialNumber = rds.di_refresh_serial_number
								INNER JOIN refresh_ewaste ew
								ON ew.device_swap_id = rds.id
								where rds.received_back = '1'
								and rds.marked_for_surplus IS NULL
								AND rds.new_equipment_id = 'ewaste_only'
								AND 
								(ew.attest_person_1_signed IS NULL
								AND ew.attest_person_2_signed IS null
								)
							</cfquery>
							
							<cfloop query="get_list">
								<cfif ArrayContains(Session.Device_Array, get_list.di_refresh_serial_number)>
								<cfelse>
									<cfset Session.Device_Array[GG][1] = get_list.id>
									<cfset Session.Device_Array[GG][2] = get_list.di_refresh_serial_number>
									<cfset Session.Device_Array[GG][3] = get_list.date_received>
									<cfset Session.Device_Array[GG][4] = get_list.received_back_by_name>
									<cfset Session.Device_Array[GG][5] = get_list.person_returning_computer_name>
									<cfset Session.Device_Array[GG][6] = get_list.new_equipment_id>
									<cfif Len(get_list.altiris_model) GT 0>
										<cfset Session.Device_Array[GG][7] = Trim(get_list.altiris_model)>
									<cfelseif Len(get_list.fldPCModel) GT 0>
										<cfset Session.Device_Array[GG][7] = Trim(get_list.altiris_model)>
									<cfelse>
										<cfset Session.Device_Array[GG][7] = "">
									</cfif>
									<cfset Session.Device_Array[GG][8] = get_list.device_counter>
									<cfset Session.Device_Array[GG][9] = get_list.form_factor>
									
									<cfset GG = GG + 1>
								</cfif>									
							</cfloop>
							
							<p>
								* = Refresh Trade-in<br>
								** = eWaste Only
							</p>
							<p>
								Total Devices: #ArrayLen(Session.Device_Array)#
							</p>
						
							<cfform action="" method="post" >												
								<table class="styled_picker stripe" id="universal_list_3">
									<thead>	
										<th>
											<strong>Select</strong>
										</th>
										<th>
											<strong>Device Counter</strong>
										</th>										
										<th>
											<strong>Serial Number</strong>
										</th>
										<th>
											<strong>Altiris Model</strong>
										</th>
										<th>
											<strong>Form Factor</strong>
										</th>
										
										<th>
											<strong>Date Received</strong>
										</th>
										<th>
											<strong>Received By</strong>
										</th>	
										<th>
											<strong>Returned By</strong>
										</th>
										<cfif Session.CRM_Interface_Super_Admin>
											<th>
												Action
											</th>	
										</cfif>																																																											
									</thead>										
									<tbody>
										<cfloop index="GG" from="1" to="#ArrayLen(Session.Device_Array)#">
											<tr>
												<td>
													<cfset Field_Name = "surplus," & #Session.Device_Array[GG][1]#>
													<cfinput name="#field_name#" type="checkbox" value="#get_list.id#">
												</td>
												<td>
													#Session.Device_Array[GG][8]#
												</td>
												<td>													
													<cfif Session.Device_Array[GG][6] EQ "ewaste_only">
														&nbsp; **
													<cfelse>
														&nbsp; *
													</cfif>
													#Session.Device_Array[GG][2]#
												</td>
												<td>
													#Session.Device_Array[GG][7]#
												</td>
												<td>
													#Session.Device_Array[GG][9]#
												</td>
												<td>
													#DateFormat(Session.Device_Array[GG][3], "mm/DD/yyyy")#
												</td>
												<td>
													#Session.Device_Array[GG][4]#
												</td>
												<td>
													#Session.Device_Array[GG][5]#
												</td>
												<cfif Session.CRM_Interface_Super_Admin>	
													<td>
														<a class="action-icon" href="" data-bs-toggle="modal" data-bs-target="##delete_ewaste_modal"  data-backdrop="static" data-remote="modal_delete_ewaste.cfm?ID=#Session.Device_Array[GG][1]#" style="text-decoration:none;">
									                    	<i class="bi bi-trash" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Delete Item" aria-label="Delete Item">
								                        	</i>
						                        		</a>
													</td>	
												</cfif>																			
											</tr>
										</cfloop> 
									</tbody>
								</table>
								
								<div class="row">
									<div class="col-sm-12">											
										&nbsp;																					
	  								</div>  										  							
	  							</div>
	  						
		  						<div class="row">
									<div class="col-sm-12">								
										<cfinput type="submit" name="step_1" value="Next" class="btn btn-primary">								
									</div>			  								
	  							</div>
							</cfform>		
						</cfif>
						
						<cfif Session.Surplus_Page_Status EQ 10>
							<cfset Session.Surplus_Page_Status = 0>
							<cfset GoodData = 1>
							
							<cfset Session.One_device_selected = 0>
							<cfset Session.Selected_Device_Array = ArrayNew(1)>
							<cfset GG = 1>
							
							<cfset keysToStruct = StructKeyArray(form)>
							<CFLOOP index = "ZZ" from = "1" to = "#ArrayLen(keysToStruct)#">
					        	<cfset TempArray = ArrayNew(1)>
					            <cfset TempArray = ListToArray(#keysToStruct[ZZ]# )>
					            <cfif ArrayLen(TempArray) GT "1">
					            	<cfif TempArray[1] EQ "surplus">
					            		<cfset Session.One_device_selected = 1>
					            		<cfset Session.Selected_Device_Array[GG] = TempArray[2]>
					            		<cfset GG = GG + 1>
					            	</cfif>
								</cfif>
					        </CFLOOP>
					        
					        <cfif Not Session.One_device_selected>
					        	<cfset GoodData = 0>
					        	<div>
									<div class="alert alert-danger">
										You must select at least one device for eWaste disposal			
									</div>
								</div>
					        </cfif>
							
							<cfif GoodData>
								<cfquery name="get_Staff" datasource="#DSN#">
									SELECT *
									FROM dbo.refresh_crs_list
									WHERE active = '1'
									AND ais_staff = '1'
									ORDER BY lname
								</cfquery>
								
								<div class="row">
									<div class="col-sm-12">											
										&nbsp;																					
	  								</div>  										  							
	  							</div>
	  							
	  							<cfform action="" method="post" >
		  							<div class="row">
										<div class="col-sm-3">											
											<strong>Warehouse Delivery Date:</strong>																					
		  								</div>  
		  								<div class="col-sm-3">					
		  									<cfset Session.Min_date = DateFormat(Session.DateNow,"yyyy-mm-DD")>				
											<input name="drop_off_date" type="date" min="#Session.Min_date#" max="2030-12-31" class="form-control">																				
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
										<div class="col-sm-4">											
											<strong>Attestation Individuals	(select 2)</strong>																								
		  								</div>  
		  								<div class="col-sm-8">											
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
																					
											<table class="styled_picker stripe" id="universal_list_no">
												<thead>	
													<th>
														<strong>Select</strong>
													</th>
													<th>
														<strong>Staff</strong>
													</th>																																																																														
												</thead>										
												<tbody>
													<cfloop query="get_Staff" >
														<tr>
															<td>
																<cfset field_name = "attest," & #get_Staff.kerberos_id#>
																<cfinput name="#field_name#" type="checkbox" >
															</td>
															<td>
																#get_Staff.lname#, #get_Staff.fname#
															</td>
														</tr>
													</cfloop>
												</tbody>
											</table>
											
											<div class="row">
												<div class="col-sm-12">											
													&nbsp;																					
				  								</div>  										  							
				  							</div>
				  						
					  						<div class="row">
												<div class="col-sm-12">								
													<cfinput type="submit" name="step_2" value="Next" class="btn btn-primary">								
												</div>			  								
				  							</div>																													
	  									</div>  										  							
	  								</div> 
	  							</cfform>
	  						</cfif> 					
						</cfif>
						
						<cfif Session.Surplus_Page_Status EQ 20>
							<cfset Session.Surplus_Page_Status = 0>
							<cfset GoodData = 1>
							
							<cfif IsDefined("form.drop_off_date")>
								<cfset Session.drop_off_date = DateFormat(form.drop_off_date, "mm/DD/yyyy")>
								<cfset Session.drop_off_date = Trim(ReReplaceNoCase(#Session.drop_off_date#,"[^0-9/]","","ALL"))>
								<cfif Len(Session.drop_off_date) EQ 0>
									<cfset GoodData = 0>
									<div>
										<div class="alert alert-danger">
											You did not specify the drop off date				
										</div>
									</div>
								</cfif>
							<cfelse>
								<cfset GoodData = 0>
								<div>
									<div class="alert alert-danger">
										You did not specify the drop off date				
									</div>
								</div>
							</cfif>
							
							<cfset Session.two_staff_selected = 0>
							<cfset Session.Selected_Staff_Array = ArrayNew(1)>
							<cfset GG = 1>
							
							<cfset keysToStruct = StructKeyArray(form)>
							<CFLOOP index = "ZZ" from = "1" to = "#ArrayLen(keysToStruct)#">
					        	<cfset TempArray = ArrayNew(1)>
					            <cfset TempArray = ListToArray(#keysToStruct[ZZ]# )>
					            <cfif ArrayLen(TempArray) GT "1">
					            	<cfif TempArray[1] EQ "attest">					            		
					            		<cfset Session.Selected_Staff_Array[GG] = TempArray[2]>
					            		<cfset GG = GG + 1>
					            	</cfif>
								</cfif>
					        </CFLOOP>
					        
					        <cfif ARRAYLEN(Session.Selected_Staff_Array) EQ 2>
					        	<cfset Session.two_staff_selected = 1>
					        </cfif>
					        
					        <cfif Not Session.two_staff_selected>
					        	<cfset GoodData = 0>
					        	<div>
									<div class="alert alert-danger">
										You must select two individuals to attest to the eWaste drop off 			
									</div>
								</div>
					        </cfif>
							
					        <cfif GoodData>
					        	<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>
								<div class="row">
									<div class="col-lg-12">
										<h3>Summary</h3>
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										Count of computer devices for ewaste drop off: <strong>#ArrayLen(Session.Selected_Device_Array)#</strong>
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										Drop off Date: <strong>#Session.drop_off_date#</strong>
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										AIS Staff Attesting to Drop Off:
										<br>
										<cfloop index="GG" from="1" to="#ArrayLen(Session.Selected_Staff_Array)#" >
											<cfquery name="get_Staff" datasource="#DSN#">
												SELECT *
												FROM dbo.refresh_crs_list
												WHERE kerberos_id = <cfqueryparam value="#Session.Selected_Staff_Array[GG]#" cfsqltype="cf_sql_longvarchar" >												
											</cfquery>
											<strong>#get_Staff.lname#, #get_Staff.fname#</strong>
											<br>
										</cfloop>
									</div>
								</div>
								
								<div class="row">
									<div class="col-lg-12">
										&nbsp;
									</div>
								</div>
								
								<div class="row">
									<div class="col-sm-12">											
										<cfform action="" method="post" >											
										
											<div class="row">
												<div class="col-sm-12">											
													&nbsp;																					
				  								</div>  										  							
				  							</div>
				  						
					  						<div class="row">
												<div class="col-sm-12">								
													<cfinput type="submit" name="step_3" value="Submit" class="btn btn-primary">								
												</div>			  								
				  							</div>
										</cfform>																				
	  								</div>  										  							
	  							</div> 
					        </cfif>
						</cfif>
						
						<cfif Session.Surplus_Page_Status EQ 30>
							<cfset Session.Surplus_Page_Status = 0>
							<cfset GoodData = 1>
							
							<cfset Session.Attest_Staff_1 = Lcase(Session.Selected_Staff_Array[1])>								
							
							<cfset Session.Attest_Staff_2 = Lcase(Session.Selected_Staff_Array[2])>	
																									
							<cfloop index="GG" from="1" to="#ArrayLen(Session.Selected_Device_Array)#">
								<cfquery name="update_data" datasource="#DSN#">
			            			Update refresh_device_swap
			            			set marked_for_surplus = '1', marked_for_surplus_date = '#Session.dateNow#', marked_for_surplus_by = '#Session.cas_user_name#'
			            			where id = <cfqueryparam value="#Session.Selected_Device_Array[GG]#" cfsqltype="cf_sql_longvarchar" >
			            		</cfquery>
			            		
			            		<cfquery name="update_data" datasource="#DSN#">
			            			Update refresh_ewaste
			            			set attest_person_1 =  '#Session.Attest_Staff_1#', attest_person_2 = '#Session.Attest_Staff_2#', attest_person_1_date = '#Session.DateNow#', attest_person_2_date = '#Session.DateNow#',
			            			warehouse_delivery_date = '#Session.drop_off_date#'
			            			where device_swap_id = <cfqueryparam value="#Session.Selected_Device_Array[GG]#" cfsqltype="cf_sql_longvarchar" >
			            		</cfquery>
							</cfloop>
							
							<cfset Session.Device_report_array = ArrayNew(2)>
							<cfset TT = 1>
							
							<cfloop index="GG" from="1" to="#ArrayLen(Session.Selected_Device_Array)#">
								<cfquery name="report_data" datasource="#DSN#">
									SELECT ew.warehouse_delivery_date,
									       ew.attest_person_1,
									       ew.attest_person_2,
									       ew.device_counter,
										   ds.di_refresh_serial_number
									FROM refresh_ewaste ew
									INNER JOIN dbo.refresh_device_swap ds
									ON ew.device_swap_id = ds.id
									WHERE ds.id = <cfqueryparam value="#Session.Selected_Device_Array[GG]#" cfsqltype="cf_sql_longvarchar" >
								</cfquery>							
								
								<cfset Session.Device_report_array[TT][1] = Trim(report_Data.warehouse_delivery_date)>
								<cfset Session.Device_report_array[TT][2] = Trim(report_Data.attest_person_1)>
								<cfset Session.Device_report_array[TT][3] = Trim(report_Data.attest_person_2)>
								<cfset Session.Device_report_array[TT][4] = Trim(report_Data.device_counter)>
								<cfset Session.Device_report_array[TT][5] = Trim(report_Data.di_refresh_serial_number)>
								<cfset TT = TT + 1>								
							</cfloop>
												
							<cfset Session.Header_Row = "delivery_date,attesting_person_1,attesting_person_2,counter,serial_number">
							<cfset Session.File_Date = Dateformat(Now(), "mm-DD-yyyy")>
							<cfset Session.File_Time = Timeformat(Now(), "hh_mm_ss")>
							<cfset Session.export_file_name = "eWaste_Delivery_" & Session.File_Date & "_" & Session.File_Time & ".csv">												
							<cfset Session.Destination_File = #Session.file_upload_tmp# & #Session.export_file_name#>
							<cffile action="write" file="#Session.Destination_File#" output="#Session.Header_Row#" addnewline="yes">
							
							<cfloop index="TT" from="1" to="#ArrayLen(Session.Device_report_array)#">
								<cfset Session.Report_Line = DateFormat(Session.Device_report_array[TT][1], "mm/DD/yyyy") & #CHR(44)# & Session.Device_report_array[TT][2] & #CHR(44)# & Session.Device_report_array[TT][3] & #CHR(44)# & Session.Device_report_array[TT][4] & #CHR(44)# & Session.Device_report_array[TT][5] & #CHR(13)#>															
								<cffile action="append" file="#Session.Destination_File#" output="#Session.Report_Line#" addnewline="yes">
							</cfloop>
							
							<cfloop index="TT" from="1" to="#ArrayLen(Session.Selected_Staff_Array)#">
								<cfquery name="get_email" datasource="#DSN#">
									select *
									from refresh_crs_list
									where kerberos_id = <cfqueryparam value="#Session.Selected_Staff_Array[TT]#" cfsqltype="cf_sql_longvarchar" >
								</cfquery>
								<cfset Session.RecipEmail = #Trim(get_email.email_address)#>
								
								<cfif cgi.SERVER_NAME contains "dev.ucdmc.ucdavis.edu">
									<cfset Session.RecipEmail = "AIS-CF-Mailbox@health.ucdavis.edu">
								<cfelseif cgi.SERVER_NAME contains "test.ucdmc.ucdavis.edu">
									<cfset Session.RecipEmail = "AIS-CF-Mailbox@health.ucdavis.edu">
								<cfelse>
									<cfset Session.RecipEmail = #Session.RecipEmail#>
								</cfif>
									
								<cfmail from="hs-web-noreply@ucdavis.edu" subject="eWaste Delivery" to="#Session.RecipEmail#" type="html" priority="highest" >
									#Trim(get_email.fname)# #Trim(get_email.lname)#,
									<br><br>
															
									The attached file is the most recent eWaste delivery scheduled
									<br><br>								
									<cfmailparam file = "#Session.Destination_File#" type="text/csv">
								</cfmail>
							</cfloop>
							   
					        <div>
				    			<div class="alert alert-success">
				    				Equipment marked for e-waste delivery & email sent
				    			</div>
				    		</div>
				    		
						</cfif>
					</div>					
				</div><!-- end .container -->
		    </div><!-- end content -->
		    </cfoutput>
		    
		    <!--- Modal --->
			<div class="modal fade" id="help_manage_access_Modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="helpModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-lg modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="helpModalLabel">Help</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="help_text.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->


			<div class="modal fade" id="add_old_device_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="NewUserModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-xl modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="NewFacModalLabel">Add Additional Device</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">
							<cfinclude template="modal_add_old_device.cfm" >
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->
			

			<div class="modal fade" id="delete_ewaste_modal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="EditModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-lg modal-dialog-scrollable" role="dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="EditModalLabel">Delete Item</h5>
							<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
							</button>
						</div>
						<div class="modal-body">

						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->	


		    <cfinclude template="/secure/common_footer.cfm" >

		    <cfinclude template="/secure/js.cfm" >

		  </body>
		</html>
	<cfelse>
		<div id="content">
			<div class="container">
				<div class="landing-menu">
					<div class="content-wrap">
						<cflocation url="no_access.cfm" addtoken="false" >
					</div>
				</div>
			</div>
		</div>
	</cfif>

	<!--- Specify the type of error for which we search. --->
	<cfcatch type = "any">
		<cfinclude template="dump.cfm">

	</cfcatch>
</cftry>
