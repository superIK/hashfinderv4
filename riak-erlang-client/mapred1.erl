-module(mapred1).
-compile(export_all).



 % Map and reduce functions are executed on Riak nodes.
 % Return 1 for every object. 
count_map(_G, _KeyData, none) -> [1].

 % This function expects the data to be a binary holding text.

 words_dict_map(RiakObject, _, _) ->
  [dict:from_list([{I, 1} || I <- binary_to_term(riak_object:get_value(RiakObject))])].

 % Reduce function adding integers.
 add_int_red(GCounts, none) ->
  [lists:foldl(fun (G, Acc) -> G + Acc end, 0, GCounts)].

 % Reduce function for integer-valued dictionaries.

 merge_dicts_red(Input, _) ->
  [lists:foldl(
		fun(Tag, Acc) ->
			dict:merge(
				fun(_, Amount1, Amount2) ->
					Amount1 + Amount2
				end,
				Tag,
				Acc
			)
		end,
		dict:new(),
		Input
	)].
 % add checking for tombstones!

 count_objects(P, Bucket) ->
  X = riakc_pb_socket:mapred(
             P,
             Bucket,
             [{map, {modfun, ?MODULE, count_map}, none, false},
              {reduce, {modfun, ?MODULE, add_int_red}, none, true}]),
  X.
 % Count words interpreting values as binaries containging text.
 % This function has a bug - can you find it?
 count_words(Pid, Bucket) ->
  {ok, [{1, [Result]}]} = riakc_pb_socket:mapred(
		Pid,
		Bucket,
		[
			{map, {modfun, ?MODULE, words_dict_map}, none, false},
			{reduce, {modfun, ?MODULE, merge_dicts_red}, none, true}
		]
	),
	dict:to_list(Result).

 start(Bucket) ->

  {ok, Pid} = riakc_pb_socket:start("127.0.0.1", 10017),
  Result = count_words(Pid, Bucket).
