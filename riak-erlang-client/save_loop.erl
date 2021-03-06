-module(save_loop).
 -compile(export_all).

 loop()->
	% make connection
	Pid = connect(),
	
	% make twitter_6 bucket empty
	clean_bucket(Pid, <<"twitter_6">>),
	clean_bucket(Pid, <<"twitter_6">>),
	
	% make insta_6 bucket empty
	clean_bucket(Pid, <<"insta_6">>),
	clean_bucket(Pid, <<"insta_6">>),
	
	% exchange data between buckets for twitter
	Bucket_List1 = [<<"twitter_6">>, <<"twitter_5">>, <<"twitter_4">>, <<"twitter_3">>,
		<<"twitter_2">>, <<"twitter_1">>, <<"twitter_temp">>],
	exchange_data(Pid, Bucket_List1),
	% exchange data between buckets for twitter
	Bucket_List2 = [<<"insta_6">>, <<"insta_5">>, <<"insta_4">>, <<"insta_3">>,
		<<"insta_2">>, <<"insta_1">>, <<"insta_temp">>],
	exchange_data(Pid, Bucket_List2),
	
	% save current twitter tags in twitter_temp bucket
	% save current instagram tags in insta_temp bucket
	erl_insta_final:start(Pid),
	
	io:format("done"),
	% wait for 1 hour
	timer:sleep(60000),
	
	% continue the loop
	loop().
 connect() ->
	{ok, P} = riakc_pb_socket:start("127.0.0.1", 10017),
 	P.
 clean_bucket(P, B)->
	KeyList = get_key_list(P, B),
	clean_bucket_loop(P, B, KeyList).
 clean_bucket_loop(_P, _B, [])-> bucket_cleaned;
 clean_bucket_loop(P, B, [H|T]) ->
	riakc_pb_socket:delete(P, B, H),
  	clean_bucket_loop(P, B, T).
 exchange_data(_P, [_H|[]]) -> done;
 exchange_data(P, [H1, H2|T])->
	% Data = fetch data from bucket H2
	% save this Data to bucket H1
	save_key_value_list(P, H1, get_key_list(P, H2), get_value_list(P, H2, get_key_list(P, H2))),
	
	% clean bucket H2
	clean_bucket(P, H2),
	clean_bucket(P, H2),
	% continue the loop
	exchange_data(P, [H2|T]).
 get_key_list(P, B)->
	{ok, KeyList} = riakc_pb_socket:list_keys(P, B),
	KeyList.
 get_value(P, B, K)->
	{ok, {riakc_obj, _, _, _, [{_, Val}], _, _}} = riakc_pb_socket:get(P, B, K),Val.
 get_value_list(P, B, L)-> get_value_list(P, B, L, []).
 get_value_list(_, _, [], Acc)-> Acc; 
get_value_list(P, B, [H|T], Acc)-> get_value_list(P, B, T, Acc++[get_value(P, B, H)]).

 save_key_value_list(_, _, [], _)-> all_saved;
 save_key_value_list(_, _, _, [])-> all_saved;
 save_key_value_list(P, B, [K1|K], [V1|V])->
	riakc_pb_socket:put(P, riakc_obj:new(B, K1, V1)),
	save_key_value_list(P, B, K, V).
