<?php

require_once('riak-php-client/src/Basho/Riak/Riak.php');
require_once('riak-php-client/src/Basho/Riak/Bucket.php');
require_once('riak-php-client/src/Basho/Riak/Exception.php');
require_once('riak-php-client/src/Basho/Riak/Link.php');
require_once('riak-php-client/src/Basho/Riak/MapReduce.php');
require_once('riak-php-client/src/Basho/Riak/Object.php');
require_once('riak-php-client/src/Basho/Riak/StringIO.php');
require_once('riak-php-client/src/Basho/Riak/Utils.php');
require_once('riak-php-client/src/Basho/Riak/Link/Phase.php');
require_once('riak-php-client/src/Basho/Riak/MapReduce/Phase.php');


$top5_results = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/cur_top5_both');
$top5 = str_replace('}','',$top5_results);
$top5 = explode('{',$top5);
$nr1 = explode(',',$top5[1]);
$nr2 = explode(',',$top5[2]);
$nr3 = explode(',',$top5[3]);
$nr4 = explode(',',$top5[4]);
$nr5 = explode(',',$top5[5]);


$top5_results_instagram = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/cur_top5_inst');
$top5_instagram = str_replace('}','',$top5_results_instagram);
$top5_instagram = explode('{',$top5_instagram);
$nr1_instagram = explode(',',$top5_instagram[1]);
$nr2_instagram = explode(',',$top5_instagram[2]);
$nr3_instagram = explode(',',$top5_instagram[3]);
$nr4_instagram = explode(',',$top5_instagram[4]);
$nr5_instagram = explode(',',$top5_instagram[5]);


$top5_results_twitter = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/cur_top5_twit');
$top5_twitter = str_replace('}','',$top5_results_twitter);
$top5_twitter = explode('{',$top5_twitter);
$nr1_twitter = explode(',',$top5_twitter[1]);
$nr2_twitter = explode(',',$top5_twitter[2]);
$nr3_twitter = explode(',',$top5_twitter[3]);
$nr4_twitter = explode(',',$top5_twitter[4]);
$nr5_twitter = explode(',',$top5_twitter[5]);


$top5_results_hist = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/his_top5_both');
$top5_hist = str_replace('}','',$top5_results_hist);
$top5_hist = explode('{',$top5_hist);
$nr1_hist_plot = explode(',',$top5_hist[3]);
$nr1_hist_tag = explode(',',$top5_hist[2]);
$nr1_hist_plot = str_replace(' ',',',rtrim(implode($nr1_hist_plot)));
$nr2_hist_plot = explode(',',$top5_hist[6]);
$nr2_hist_tag = explode(',',$top5_hist[5]);
$nr2_hist_plot = str_replace(' ',',',rtrim(implode($nr2_hist_plot)));
$nr3_hist_plot = explode(',',$top5_hist[9]);
$nr3_hist_tag = explode(',',$top5_hist[8]);
$nr3_hist_plot = str_replace(' ',',',rtrim(implode($nr3_hist_plot)));
$nr4_hist_plot = explode(',',$top5_hist[12]);
$nr4_hist_tag = explode(',',$top5_hist[11]);
$nr4_hist_plot = str_replace(' ',',',rtrim(implode($nr4_hist_plot)));
$nr5_hist_plot = explode(',',$top5_hist[15]);
$nr5_hist_tag = explode(',',$top5_hist[14]);
$nr5_hist_plot = str_replace(' ',',',rtrim(implode($nr5_hist_plot)));


$top5_results_hist_instagram = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/his_top5_inst');
$top5_hist_instagram = str_replace('}','',$top5_results_hist_instagram);
$top5_hist_instagram = explode('{',$top5_hist_instagram);
$nr1_hist_plot_instagram = explode(',',$top5_hist_instagram[3]);
$nr1_hist_tag_instagram = explode(',',$top5_hist_instagram[2]);
$nr1_hist_plot_instagram = str_replace(' ',',',rtrim(implode($nr1_hist_plot_instagram)));
$nr2_hist_plot_instagram = explode(',',$top5_hist_instagram[6]);
$nr2_hist_tag_instagram = explode(',',$top5_hist_instagram[5]);
$nr2_hist_plot_instagram = str_replace(' ',',',rtrim(implode($nr2_hist_plot_instagram)));
$nr3_hist_plot_instagram = explode(',',$top5_hist_instagram[9]);
$nr3_hist_tag_instagram = explode(',',$top5_hist_instagram[8]);
$nr3_hist_plot_instagram = str_replace(' ',',',rtrim(implode($nr3_hist_plot_instagram)));
$nr4_hist_plot_instagram = explode(',',$top5_hist_instagram[12]);
$nr4_hist_tag_instagram = explode(',',$top5_hist_instagram[11]);
$nr4_hist_plot_instagram = str_replace(' ',',',rtrim(implode($nr4_hist_plot_instagram)));
$nr5_hist_plot_instagram = explode(',',$top5_hist_instagram[15]);
$nr5_hist_tag_instagram = explode(',',$top5_hist_instagram[14]);
$nr5_hist_plot_instagram = str_replace(' ',',',rtrim(implode($nr5_hist_plot_instagram)));


$top5_results_hist_twitter = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/his_top5_twit');
$top5_hist_twitter = str_replace('}','',$top5_results_hist_twitter);
$top5_hist_twitter = explode('{',$top5_hist_twitter);
$nr1_hist_plot_twitter = explode(',',$top5_hist_twitter[3]);
$nr1_hist_tag_twitter = explode(',',$top5_hist_twitter[2]);
$nr1_hist_plot_twitter = str_replace(' ',',',rtrim(implode($nr1_hist_plot_twitter)));
$nr2_hist_plot_twitter = explode(',',$top5_hist_twitter[6]);
$nr2_hist_tag_twitter = explode(',',$top5_hist_twitter[5]);
$nr2_hist_plot_twitter = str_replace(' ',',',rtrim(implode($nr2_hist_plot_twitter)));
$nr3_hist_plot_twitter = explode(',',$top5_hist_twitter[9]);
$nr3_hist_tag_twitter = explode(',',$top5_hist_twitter[8]);
$nr3_hist_plot_twitter = str_replace(' ',',',rtrim(implode($nr3_hist_plot_twitter)));
$nr4_hist_plot_twitter = explode(',',$top5_hist_twitter[12]);
$nr4_hist_tag_twitter = explode(',',$top5_hist_twitter[11]);
$nr4_hist_plot_twitter = str_replace(' ',',',rtrim(implode($nr4_hist_plot_twitter)));
$nr5_hist_plot_twitter = explode(',',$top5_hist_twitter[15]);
$nr5_hist_tag_twitter = explode(',',$top5_hist_twitter[14]);
$nr5_hist_plot_twitter = str_replace(' ',',',rtrim(implode($nr5_hist_plot_twitter)));


$page = $_GET["page"];
$source = $_GET["source"];
$search_field = $_GET["search"];

?>

<!DOCTYPE html>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="design.css" />

		<!--[if lt IE 9]><script language="javascript" type="text/javascript" src="excanvas.js"></script><![endif]-->
		<script language="javascript" type="text/javascript" src="jquery.min.js"></script>
		<script language="javascript" type="text/javascript" src="jquery.jqplot.min.js"></script>




		<script type="text/javascript" src="jqplot.barRenderer.min.js"></script>
		<script type="text/javascript" src="jqplot.categoryAxisRenderer.min.js"></script>
		<script type="text/javascript" src="jqplot.pointLabels.min.js"></script>








		<link rel="stylesheet" type="text/css" href="jquery.jqplot.css" />

		<title>#Finder</title>
	</head>

	<body>



		<div id="logo">Hashfinder</div>

		<div id="header">
			<a href="?page=current&source=both">Current</a>
			<a href="?page=history&source=both">History#</a>
			<a href="prediction.html">Predicting#Trends</a>
				<form action="index.php?page=search" method="GET">
					<input type="text" name="search">
					<input type="submit" value="Search" />
				</form>
		</div>




        <div id="header">
			<a href="?page=<?php print($page);?>&source=both">Both</a>
			<a href="?page=<?php print($page);?>&source=twitter">Twitter</a>
			<a href="?page=<?php print($page);?>&source=instagram">Instagram</a>
		</div>
		<div id="content">
			<h1>Top 5#</h1>
			<p>The 5 highest ranked hashtags:</p>

			<div id="chart4" style="height:400px;width:600px; ">

				
				<script>
<?php
if ($page == "current" AND $source == "both") { ?>


					    $(document).ready(function(){
  						var line1 = [<?php print($nr1[3]); ?>, <?php print($nr2[3]); ?>, <?php print($nr3[3]); ?>, <?php print($nr4[3]); ?>, <?php print($nr5[3]); ?>];
  						var line2 = [<?php print($nr1[2]); ?>, <?php print($nr2[2]); ?>, <?php print($nr3[2]); ?>, <?php print($nr4[2]); ?>, <?php print($nr5[2]); ?>];
  						var ticks = ['#<?php print($nr1[0]); ?>','#<?php print($nr2[0]); ?>','#<?php print($nr3[0]); ?>','#<?php print($nr4[0]); ?>','#<?php print($nr5[0]); ?>'];
  						var plot4 = $.jqplot('chart4', [line1, line2], {
      					title: 'Current Top 5', 
      					stackSeries: true, 
      					seriesDefaults: {
          				renderer: $.jqplot.BarRenderer,
          				rendererOptions:{barMargin: 25}, 
          			pointLabels:{show:true}
      				},

      				series:[{label:'Twitter'}, {label:'Instragram'}],
			        // Show the legend and put it outside the grid, but inside the
			        // plot container, shrinking the grid to accomodate the legend.
			        // A value of "outside" would not shrink the grid and allow
			        // the legend to overflow the container.
			        legend: {
			            show: true,
			            placement: 'outsideGrid'
			        },
				      axes: {
				      xaxis:{
				      		renderer:$.jqplot.CategoryAxisRenderer,ticks: ticks
				      	},

				           yaxis:{ show:true, label:'No of posts'}
				      }
				  });
				});




				</script>


			</div>


		</div> <?php
}
				
if ($page == "current" AND $source == "instagram") { ?>


					$(document).ready(function(){
  						var line2 = [<?php print($nr1_instagram[1]); ?>, <?php print($nr2_instagram[1]); ?>, <?php print($nr3_instagram[1]); ?>, <?php print($nr4_instagram[1]); ?>, <?php print($nr5_instagram[1]); ?>];
  						var ticks = ['#<?php print($nr1_instagram[0]); ?>','#<?php print($nr2_instagram[0]); ?>','#<?php print($nr3_instagram[0]); ?>','#<?php print($nr4_instagram[0]); ?>','#<?php print($nr5_instagram[0]); ?>'];
  						var plot4 = $.jqplot('chart4', [line2], {
      					title: 'Current Top 5 for Instagram', 
      					stackSeries: true, 
      					seriesDefaults: {
          				renderer: $.jqplot.BarRenderer,
          				rendererOptions:{barMargin: 25}, 
          			pointLabels:{show:true}
      				},

      				series:[{label:'Instagram'}],
			        // Show the legend and put it outside the grid, but inside the
			        // plot container, shrinking the grid to accomodate the legend.
			        // A value of "outside" would not shrink the grid and allow
			        // the legend to overflow the container.
			        legend: {
			            show: true,
			            placement: 'outsideGrid'
			        },
				      axes: {
				      xaxis:{
				      		renderer:$.jqplot.CategoryAxisRenderer,ticks: ticks
				      	},

				           yaxis:{ show:true, label:'No of posts'}
				      }
				  });
				});




				</script>


			</div>


		</div> <?php
}
	
if ($page == "current" AND $source == "twitter") { ?>


					$(document).ready(function(){
  						var line2 = [<?php print($nr1_twitter[1]); ?>, <?php print($nr2_twitter[1]); ?>, <?php print($nr3_twitter[1]); ?>, <?php print($nr4_twitter[1]); ?>, <?php print($nr5_twitter[1]); ?>];
  						var ticks = ['#<?php print($nr1_twitter[0]); ?>','#<?php print($nr2_twitter[0]); ?>','#<?php print($nr3_twitter[0]); ?>','#<?php print($nr4_twitter[0]); ?>','#<?php print($nr5_twitter[0]); ?>'];
  						var plot4 = $.jqplot('chart4', [line2], {
      					title: 'Current Top 5 for Twitter', 
      					stackSeries: true, 
      					seriesDefaults: {
          				renderer: $.jqplot.BarRenderer,
          				rendererOptions:{barMargin: 25}, 
          			pointLabels:{show:true}
      				},

      				series:[{label:'Twitter'}],
			        // Show the legend and put it outside the grid, but inside the
			        // plot container, shrinking the grid to accomodate the legend.
			        // A value of "outside" would not shrink the grid and allow
			        // the legend to overflow the container.
			        legend: {
			            show: true,
			            placement: 'outsideGrid'
			        },
				      axes: {
				      xaxis:{
				      		renderer:$.jqplot.CategoryAxisRenderer,ticks: ticks
				      	},

				           yaxis:{ show:true, label:'No of posts'}
				      }
				  });
				});




				</script>


			</div>


		</div> <?php
}

if ($page == "history" AND $source == "both") { ?>

$(document).ready(function(){
  // Some simple loops to build up data arrays.
  var Point1 = [<?php print($nr1_hist_plot);?>]; 
  var Point2 = [<?php print($nr2_hist_plot);?>]; 
  var Point3 = [<?php print($nr3_hist_plot);?>];
  var Point4 = [<?php print($nr4_hist_plot);?>];
  var Point5 = [<?php print($nr5_hist_plot);?>]; 
  
  var plot3 = $.jqplot('chart4', [Point1, Point2, Point3, Point4, Point5], 
    { 
      title:'History', 
      // Series options are specified as an array of objects, one object
      // for each series.
      seriesDefault:{
      	renderOptions: {
      		smooth: true
      	}
      },
       legend: {
        show: true,
        location: 'ne',     // compass direction, nw, n, ne, e, se, s, sw, w.
        xoffset: 12,        // pixel offset of the legend box from the x (or x2) axis.
        yoffset: 12,        // pixel offset of the legend box from the y (or y2) axis.
    },
      series:[ 
          {
            // Change our line width and use a diamond shaped marker.
            lineWidth:2, 
            color: 'GREEN',
            label: '#<?php print($nr1_hist_tag[0]);?>',
            markerOptions: { style:'dimaond' }
          }, 
          {
            // Don't show a line, just show markers.
            // Make the markers 7 pixels with an 'x' style
         	color: 'ORANGE',
         	label: '#<?php print($nr2_hist_tag[0]);?>',
            markerOptions: { size: 7, style:"x" }
          },
          { 
            // Use (open) circlular markers.
            color: 'RED',
            label: '#<?php print($nr3_hist_tag[0]);?>',
            markerOptions: { style:"circle" }
          }, 
          {
            // Use a thicker, 5 pixel line and 10 pixel
            // filled square markers.
            lineWidth:2, 
            color: 'PURPLE',
            label: '#<?php print($nr4_hist_tag[0]);?>',
            markerOptions: { style:"filledSquare", size:10 }
          },
          {
            // Use a thicker, 5 pixel line and 10 pixel
            // filled square markers.
            lineWidth:2, 
            color: 'MAROON',
            label: '#<?php print($nr5_hist_tag[0]);?>',
            markerOptions: { style:"filledSquare", size:10 }
          }
      ]
    }
  );
    
});
				
		
				</script>


			</div>


		</div>
<?php
}

if ($page == "history" AND $source == "instagram") { ?>

$(document).ready(function(){
  // Some simple loops to build up data arrays.
  var Point1 = [<?php print($nr1_hist_plot_instagram);?>]; 
  var Point2 = [<?php print($nr2_hist_plot_instagram);?>]; 
  var Point3 = [<?php print($nr3_hist_plot_instagram);?>];
  var Point4 = [<?php print($nr4_hist_plot_instagram);?>];
  var Point5 = [<?php print($nr5_hist_plot_instagram);?>]; 
  
  var plot3 = $.jqplot('chart4', [Point1, Point2, Point3, Point4, Point5], 
    { 
      title:'History', 
      // Series options are specified as an array of objects, one object
      // for each series.
      seriesDefault:{
      	renderOptions: {
      		smooth: true
      	}
      },
       legend: {
        show: true,
        location: 'ne',     // compass direction, nw, n, ne, e, se, s, sw, w.
        xoffset: 12,        // pixel offset of the legend box from the x (or x2) axis.
        yoffset: 12,        // pixel offset of the legend box from the y (or y2) axis.
    },
      series:[ 
          {
            // Change our line width and use a diamond shaped marker.
            lineWidth:2, 
            color: 'GREEN',
            label: '#<?php print($nr1_hist_tag_instagram[0]);?>',
            markerOptions: { style:'dimaond' }
          }, 
          {
            // Don't show a line, just show markers.
            // Make the markers 7 pixels with an 'x' style
         	color: 'ORANGE',
         	label: '#<?php print($nr2_hist_tag_instagram[0]);?>',
            markerOptions: { size: 7, style:"x" }
          },
          { 
            // Use (open) circlular markers.
            color: 'RED',
            label: '#<?php print($nr3_hist_tag_instagram[0]);?>',
            markerOptions: { style:"circle" }
          }, 
          {
            // Use a thicker, 5 pixel line and 10 pixel
            // filled square markers.
            lineWidth:2, 
            color: 'PURPLE',
            label: '#<?php print($nr4_hist_tag_instagram[0]);?>',
            markerOptions: { style:"filledSquare", size:10 }
          },
          {
            // Use a thicker, 5 pixel line and 10 pixel
            // filled square markers.
            lineWidth:2, 
            color: 'MAROON',
            label: '#<?php print($nr5_hist_tag_instagram[0]);?>',
            markerOptions: { style:"filledSquare", size:10 }
          }
      ]
    }
  );
    
});
				
		
				</script>


			</div>


		</div>
<?php
}


if ($page == "history" AND $source == "twitter") { ?>

$(document).ready(function(){
  // Some simple loops to build up data arrays.
  var Point1 = [<?php print($nr1_hist_plot_twitter);?>]; 
  var Point2 = [<?php print($nr2_hist_plot_twitter);?>]; 
  var Point3 = [<?php print($nr3_hist_plot_twitter);?>];
  var Point4 = [<?php print($nr4_hist_plot_twitter);?>];
  var Point5 = [<?php print($nr5_hist_plot_twitter);?>]; 
  
  var plot3 = $.jqplot('chart4', [Point1, Point2, Point3, Point4, Point5], 
    { 
      title:'History', 
      // Series options are specified as an array of objects, one object
      // for each series.
      seriesDefault:{
      	renderOptions: {
      		smooth: true
      	}
      },
       legend: {
        show: true,
        location: 'ne',     // compass direction, nw, n, ne, e, se, s, sw, w.
        xoffset: 12,        // pixel offset of the legend box from the x (or x2) axis.
        yoffset: 12,        // pixel offset of the legend box from the y (or y2) axis.
    },
      series:[ 
          {
            // Change our line width and use a diamond shaped marker.
            lineWidth:2, 
            color: 'GREEN',
            label: '#<?php print($nr1_hist_tag_twitter[0]);?>',
            markerOptions: { style:'dimaond' }
          }, 
          {
            // Don't show a line, just show markers.
            // Make the markers 7 pixels with an 'x' style
         	color: 'ORANGE',
         	label: '#<?php print($nr2_hist_tag_twitter[0]);?>',
            markerOptions: { size: 7, style:"x" }
          },
          { 
            // Use (open) circlular markers.
            color: 'RED',
            label: '#<?php print($nr3_hist_tag_twitter[0]);?>',
            markerOptions: { style:"circle" }
          }, 
          {
            // Use a thicker, 5 pixel line and 10 pixel
            // filled square markers.
            lineWidth:2, 
            color: 'PURPLE',
            label: '#<?php print($nr4_hist_tag_twitter[0]);?>',
            markerOptions: { style:"filledSquare", size:10 }
          },
          {
            // Use a thicker, 5 pixel line and 10 pixel
            // filled square markers.
            lineWidth:2, 
            color: 'MAROON',
            label: '#<?php print($nr5_hist_tag_twitter[0]);?>',
            markerOptions: { style:"filledSquare", size:10 }
          }
      ]
    }
  );
    
});
				
		
				</script>


			</div>


		</div>
<?php
}

if (!empty($search_field)) { 
 
$search_twitter_url = 'http://localhost:10018/solr/twitter_temp/select?q=hashtag:'. $search_field. '&wt=json';
$search_results_twitter = file_get_contents($search_twitter_url);
$search_results_twitter = json_decode($search_results_twitter);
$num_twitter = $search_results_twitter->response->numFound;

$search_instagram_url = 'http://localhost:10018/solr/insta_temp/select?q='. $search_field. '&wt=json';
$search_results_instagram = file_get_contents($search_instagram_url);
$search_results_instagram = json_decode($search_results_instagram);
$num_instagram = $search_results_instagram->response->numFound;

$num_both = $num_twitter+$num_instagram;
 ?>


					$(document).ready(function(){
  						var line2 = [<?php print($num_twitter); ?>, <?php print($num_instagram); ?>, <?php print($num_both); ?>];
  						var ticks = ['Twitter','Instagram','Total'];
  						var plot4 = $.jqplot('chart4', [line2], {
      					title: 'Results for #<?php print($search_field);?>', 
      					stackSeries: true, 
      					seriesDefaults: {
          				renderer: $.jqplot.BarRenderer,
          				rendererOptions:{barMargin: 25}, 
          			pointLabels:{show:true}
      				},

      				series:[{label:'Number of tweets'}],
			        // Show the legend and put it outside the grid, but inside the
			        // plot container, shrinking the grid to accomodate the legend.
			        // A value of "outside" would not shrink the grid and allow
			        // the legend to overflow the container.
			        legend: {
			            show: true,
			            placement: 'outsideGrid'
			        },
				      axes: {
				      xaxis:{
				      		renderer:$.jqplot.CategoryAxisRenderer,ticks: ticks
				      	},

				           yaxis:{ show:true, label:'No of posts'}
				      }
				  });
				});




				</script>


			</div>


		</div> <?php
}
?>

		<div id="footer">
			<a href="file:///src/index.html">Contact</a>
		</div>


	</body>

</html>
