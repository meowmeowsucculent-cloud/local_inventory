// Code goes here
var app = angular.module('MyApp', []);
app.controller('MyCtrl', function($scope) {
  var result = {
    "Result": {

    }
  };

var xaxisval = result.Result.x,
	axisval = result.Result.y;
    
    
 var myChart = Highcharts.chart('clerkship_result', {
	  chart: {
	  	height: 130,
	  	width: 240,
	    events: {
	      render: function() {
	        const chart = this,
	          point = chart.series[0].points[0],
	          x = point.plotX + chart.plotLeft,
	          y = point.plotY + chart.plotTop,
	          size = 6;
	
	        let arrow;
	
	        if (chart.customSvgElements && chart.customSvgElements.length) {
	          chart.customSvgElements.forEach(elem => {
	            elem.destroy();
	          })
	        }
	
	        chart.customSvgElements = [];
	
	        arrow = chart.renderer.path([
	          'M', x, y,
	          'L', x - size, y - size,
	          'L', x - size / 3, y - size,
	          'L', x - size / 3, y - 3 * size,
	          'L', x + size / 3, y - 3 * size,
	          'L', x + size / 3, y - size,
	          'L', x + size, y - size,
	          'z'
	        ]).attr({
	          fill: 'orange',
	          stroke: '#000',
	          'stroke-width': 1
	        }).add().toFront();
	
	        chart.customSvgElements.push(arrow);
	      }
	    }
	  },
	  title: {
	    text: ''
	  },
	  credits: {
		      enabled: false
		  },
	  xAxis: {
	    categories: [
	      'Honors',
	      'Pass',
	      'Fail'
	    ],
	    crosshair: true
	  },
	  yAxis: {
	    min: 0,
	    max: 125,
	    tickInterval: 25,
	    title: {
	      text: 'Pct'
	    }
	  },
	  tooltip: {
	    headerFormat: '<span style="font-size:8px">{point.key}</span><table>',
	    pointFormat: '<tr><td style="color:{series.color};padding:0"></td>' +
	      '<td style="padding:0"><b>{point.y:.1f} %</b></td></tr>',
	    footerFormat: '</table>',
	    shared: true,
	    useHTML: true
	  },
	  plotOptions: {
	    column: {
	      pointPadding: 0.2,
	      borderWidth: 0
	    }
	  },
	  series: [{
	    showInLegend: false,
	    type: 'column',
	    data: [14.0, 85.0, 0.0]
	  }],
	  exporting: {
    	enabled: false
		}
	});


  
  
  $scope.chartWithContentDownload = function() {
    var doc = new jsPDF('portrait', 'pt', 'letter', true);
    var elementHandler = {
      '#ignorePDF': function(element, renderer) {
        return true;
      }
    };

    var source = document.getElementById("top-content");
    doc.fromHTML(source, 15, 15, {
      'width': 560,
      'elementHandlers': elementHandler
    });

    var svg = document.querySelector('svg');
    var canvas = document.createElement('canvas');
    var canvasIE = document.createElement('canvas');
    var context = canvas.getContext('2d');
    var DOMURL = window.URL || window.webkitURL || window;
    var data = (new XMLSerializer()).serializeToString(svg);
    canvg(canvas, data);
    var svgBlob = new Blob([data], {
      type: 'image/svg+xml;charset=utf-8'
    });

    var url = DOMURL.createObjectURL(svgBlob);

    var img = new Image();
    img.onload = function() {
      context.canvas.width = $('#clerkship_result').find('svg').width();;
      context.canvas.height = $('#clerkship_result').find('svg').height();;
      context.drawImage(img, 0, 0);
      // freeing up the memory as image is drawn to canvas
      DOMURL.revokeObjectURL(url);
      
      var dataUrl;
						if (isIEBrowser()) { // Check of IE browser 
							var svg = $('#clerkship_result').highcharts().container.innerHTML;
							canvg(canvasIE, svg);
							dataUrl = canvasIE.toDataURL('image/JPEG');
						}
						else{
							dataUrl = canvas.toDataURL('image/jpeg');
						}
	 // addImage(image, format, xPosition, yPosition, width, height)
      doc.addImage(dataUrl, 'JPEG', 20, 300, 240, 130);
	
      var bottomContent = document.getElementById("bottom-content");
      doc.fromHTML(bottomContent, 15, 650, {
        'width': 560,
        'elementHandlers': elementHandler
      });

      setTimeout(function() {
        doc.save('clerkship_result.pdf');
      }, 2000);
    };
    img.src = url;
    
  };
  
    function isIEBrowser(){
					var ieBrowser;
					var ua = window.navigator.userAgent;
					var msie = ua.indexOf("MSIE ");
  
					if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) // Internet Explorer
		{
		  ieBrowser = true;
		}
		else  //Other browser
		{
		  console.log('Other Browser');
			ieBrowser = false;
		}

	    return ieBrowser;
	};
  
});