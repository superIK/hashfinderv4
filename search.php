<?php

$search_results_twitter = file_get_contents('http://localhost:10018/solr/twitter_temp/select?q=hashtag:MTVStars&wt=json');
$search_results_twitter = json_decode($search_results_twitter);
$num_twitter = $search_results_twitter->response->numFound;

$search_results_instagram = file_get_contents('http://localhost:10018/solr/insta_temp/select?q=hashtag:MTVStars&wt=json');
$search_results_instagram = json_decode($search_results_instagram);
$num_instagram = $search_results_instagram->response->numFound;

echo $num_twitter;
echo $num_instagram;
?>
