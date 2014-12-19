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
print_r($nr5);
//print_r($top5_results);

?>
