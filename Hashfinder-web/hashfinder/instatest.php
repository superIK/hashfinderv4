<?php

$top5_results_hist = file_get_contents('http://127.0.0.1:10018/riak/insta_twitter/pre_top5_inst');
$top5_hist = str_replace('}','',$top5_results_hist);
$top5_hist = explode('{',$top5_hist);
$nr1_hist_plot = explode(',',$top5_hist[3]);
$nr1_hist_tag = explode(',',$top5_hist[2]);

$nr1_hist_plot = str_replace(' ',',',rtrim(implode($nr1_hist_plot)));
print_r($top5_hist);
//print($nr1_hist_tag[0]);
?>
