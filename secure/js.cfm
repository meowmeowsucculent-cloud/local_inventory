<cfoutput >
			<!-----
	https://www.srihash.org/
	---->

	<cfset Session.Core_Shared_Elements = "/">
	

	<!---- JS updated 8/23/22 ---->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.js" integrity="sha512-n/4gHW3atM3QqRcbCn6ewmpxcLAHGaDjpEBu4xZd47N0W2oQ+6q7oc3PXstrJYXcbNU1OHdQ1T7pAP+gi5Yu8g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	
	<script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js" integrity="sha384-ZuLbSl+Zt/ry1/xGxjZPkp9P5MEDotJcsuoHT0cM8oWr+e1Ide//SZLebdVrzb2X" crossorigin="anonymous"></script>
	<script src="https://cdn.datatables.net/v/bs5/dt-1.12.1/b-2.2.3/b-colvis-2.2.3/b-html5-2.2.3/fh-3.2.4/r-2.3.0/datatables.min.js" integrity="sha512-UA3Lm33D82gyAIx+JNUTALBQr5Ke767E2imRf3jm4ZCc3R3gK3eeFofKOE/bNp2yLJWBRTRY/1CYwbmRgIJCLw==" crossorigin="anonymous"></script>

	<script src="https://cdn.datatables.net/buttons/2.2.3/js/dataTables.buttons.min.js" integrity="sha384-h3oS/DGBfrFl5LZtSFk9RFU+pzHmURTX7+CFwAjm6QWSTdjwxCNgPIlzA/On5XBM" crossorigin="anonymous"></script>
	<script src="https://cdn.datatables.net/buttons/2.2.3/js/buttons.html5.min.js" integrity="sha384-w6vYH0WKuBqvZ0+y9bbzGf8ia1T34eMpWbxYjCEpc+3NnCKAUsaAVbA50jrb3GWu" crossorigin="anonymous"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js" integrity="sha384-v9EFJbsxLXyYar8TvBV8zu5USBoaOC+ZB57GzCmQiWfgDIjS+wANZMP5gjwMLwGv" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js" integrity="sha384-htFkmzBKFrwO7EbvHZPvJXWg0sJIkPPUTBDe6LXOU2ghApFVGQx9++EDSrKMZtHE" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js" integrity="sha384-qNRjPXKOnea7MmtbXG6HLwVyoGNFsu7ntdDOFOt3FS4vmj4MWUKyyKMjRKu0Hr4h" crossorigin="anonymous"></script>
	
	<script src="/resources/js/jquery.character-counter.min.js"></script>

	<!---Bootstrap JS Files--->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/js/bootstrap-select.min.js" integrity="sha512-yrOmjPdp8qH8hgLfWpSFhC/+R9Cj9USL8uJxYIveJZGAiedxyIxwNw4RsLDlcjNlIRR4kkHaDHSmNHAkxFTmgg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	    
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/moment.min.js" integrity="sha512-QoJS4DOhdmG8kbbHkxmB/rtPdN62cGWXAdAFWWJPvUFF1/zxcPSdAnn4HhYZSIlVoLVEJ0LesfNlusgm2bPfnA==" crossorigin="anonymous"></script>

	<script src="https://cdn.datatables.net/plug-ins/1.10.19/sorting/datetime-moment.js" integrity="sha384-moGv2nmb1PJxMQQauUowiX6hvFChqwZ3H2Pk7qEvkKUHJRtVVsGuBucp0Ez/GK4I" crossorigin="anonymous"></script>	
	
	<script src="#Session.Core_Shared_Elements#resources/js/clear.js"></script>
	
	
	<!--- character counter --->
	<!----
	https://www.jqueryscript.net/form/Flexible-Character-Counter-Plugin-jQuery.html
	---->
	
	<!--- for page loading spinner --->
	<script type="text/javascript">
		/* <![CDATA[ */_cf_loadingtexthtml="<img alt=' ' src='/resources/images/ring_spinner.gif'/> Loading...";/* ]]> */				
	</script>

</cfoutput>

<script >
	$(function () {
	  $('[data-bs-toggle="tooltip"]').tooltip()
	})
</script>


<!---- js to load data in modal for data-remote tag ---->

<script>
	$('#edit_inventory_modal').on('show.bs.modal', function (e) {

	var button = $(e.relatedTarget);
	var modal = $(this);

	// load content from HTML string
	//modal.find('.modal-body').html("Data goes here");

	// or, load content from value of data-remote url
	modal.find('.modal-body').load(button.data("remote"));
	});

	$('#inventory_loss_modal').on('show.bs.modal', function (e) {

	var button = $(e.relatedTarget);
	var modal = $(this);

	// load content from HTML string
	//modal.find('.modal-body').html("Data goes here");

	// or, load content from value of data-remote url
	modal.find('.modal-body').load(button.data("remote"));
	});

	$('#edit_expenses_modal').on('show.bs.modal', function (e) {

	var button = $(e.relatedTarget);
	var modal = $(this);

	// load content from HTML string
	//modal.find('.modal-body').html("Data goes here");

	// or, load content from value of data-remote url
	modal.find('.modal-body').load(button.data("remote"));
	});	
	
</script>

<script >
	 //*
	$(document).ready(function () {

	    $("#myTable").on('input', '.txtCal', function () {
	       // code logic here
	        var getValue=$(this).val();
	        console.log(getValue);
	    });

	 });
	//*

	 //*
	$(document).ready(function () {

	    $("#myTable").on('input', '.txtCal', function () {
	       var calculated_total_sum = 0;

	       $("#myTable .txtCal").each(function () {
	           var get_textbox_value = $(this).val();
	           if ($.isNumeric(get_textbox_value)) {
	              calculated_total_sum += parseFloat(get_textbox_value);
	              }
	            });
	              $("#total_sum_value").html(calculated_total_sum);
	       });
	  });
	//*

</script>



<!--- js scripts for datatable sorting --->
<script type="text/javascript" language="javascript" class="init">
	
	$(document).ready(function() {
		$.fn.dataTable.moment( 'MM/DD/YYYY');
		$('#universal_list_filter').DataTable( {
			"lengthMenu": [[15, 25, -1], [15, 25, "All"]],	
			"order": [[ 3, "asc" ]],	
			dom: 'lBfrtip<"actions">',
			buttons: [            
            'excelHtml5',                       
        	],	

			"stateSave": true,
			"autoWidth": true,
			"searching": true,
			"paging": true,
			"fixedHeader": true,
			"columnDefs": [ {
		      "targets": "_all",
		      "searchable": true
		    } ]
		} );
	} );	

	$(document).ready(function() {
		$.fn.dataTable.moment( 'MM/DD/YYYY');
		$('#universal_list_2').DataTable( {
			"lengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]],
			"order": [[ 3, "asc" ]],	
			dom: 'lBfrtip<"actions">',
			buttons: [            
            'excelHtml5',                       
        	],	

			"stateSave": true,
			"autoWidth": true,
			"searching": true,
			"paging": true,
			"fixedHeader": true,
			"columnDefs": [ {
		      "targets": "_all",
		      "searchable": true
		    } ]
		} );
	} );	

	$(document).ready(function() {
		$.fn.dataTable.moment( 'MM/DD/YYYY');
		$('#universal_list_3').DataTable( {
			"lengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]],
			"order": [[ 0, "asc" ]],	
			dom: 'lBfrtip<"actions">',
			buttons: [            
            'excelHtml5',                       
        	],	

			"stateSave": true,
			"autoWidth": true,
			"searching": true,
			"paging": true,
			"fixedHeader": true,
			"columnDefs": [ {
		      "targets": "_all",
		      "searchable": true,
			  "className": "dt-center"              
		    } ]
		} );
	} );		
	
</script>


<SCRIPT Language="Javascript">
	function loadPage(list) {
		location.href = list.options[list.selectedIndex].value;
	}	
</script>

<script>
    function countChar(val)
    {

     var limit = 500;

    if ( val.length > limit )
      {
      $("#comment").val(val.substring(0, limit-1));
      val.length = limit;
      }

      $("#count").html((limit)-(val.length));
      }

</script>


<!---- hiding success div on save ---->
<script type="text/javascript">
$(document).ready(function(){
    setTimeout(function(){
        $(".divclass").hide("4000")
        }, 4000);
});
</script>
<script type="text/javascript">
$(document).ready(function(){
    setTimeout(function(){
        $(".divexpire").hide("8000")
        }, 8000);
});
</script>


<!--- these scripts move the sort caret next to the column header --->
<script type="text/javascript">

	$(document).ready( function () {
	  var table = $('#access_list').DataTable();

	  table.columns().iterator( 'column', function (ctx, idx) {
	    $( table.column(idx).header() ).append('<span class="sort-icon"/>');
	  } );
	} );
	
	$(document).ready( function () {
	  var table = $('#build_list').DataTable();

	  table.columns().iterator( 'column', function (ctx, idx) {
	    $( table.column(idx).header() ).append('<span class="sort-icon"/>');
	  } );
	} );
	
	$(document).ready( function () {
	  var table = $('#inventory_list').DataTable();

	  table.columns().iterator( 'column', function (ctx, idx) {
	    $( table.column(idx).header() ).append('<span class="sort-icon"/>');
	  } );
	} );
	
</script>




