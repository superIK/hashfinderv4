-module(history).
-compile(export_all).


combine1(L, L0, L1, L2, L3, L4, L5, L6) -> combine1(L, L0, L1, L2, L3, L4, L5, L6, []).
combine1([], _, _, _, _, _, _, _, Acc) -> Acc;
combine1([{Tag,N}|T],[H0|T0],[H1|T1],[H2|T2],[H3|T3],[H4|T4],[H5|T5],[H6|T6],Acc) -> 
	combine1(T,T0,T1,T2,T3,T4,T5,T6, Acc++[[[Tag,N], [H0, H1, H2, H3, H4, H5, H6]]]).



combine1_help(L1, L2)-> combine1_help(L1, L2, []).
combine1_help([], _, Acc)-> Acc;
combine1_help([H1|T1], [H2|T2], Acc)-> combine1_help(T1, T2, Acc++[H1+H2]).

combine2(T0,T1,T2,T3,T4,T5,T6) -> [[element(1,T0), element(2,T0)+element(2,T1)+element(2,T2)+element(2,T3)+element(2,T4)
+element(2,T5)+element(2,T6)], [element(2,T0), element(2,T1), element(2,T2),element(2,T3),
element(2,T4),element(2,T5),element(2,T6)]].

combine2_help({Tag, N1}, {Tag, N2})-> {Tag, N1+N2}.

get_all_insta(BucketList) -> get_all_insta(BucketList, []).
get_all_insta([], Acc) -> Acc;
get_all_insta([Bucket1|Rest], Acc) -> 
	get_all_insta(Rest, current:marge(Acc, current:get_tags_insta(Bucket1))).


get_all_twitter(BucketList) -> get_all_twitter(BucketList, []).
get_all_twitter([], Acc) -> Acc;
get_all_twitter([Bucket1|Rest], Acc) -> 
	get_all_twitter(Rest, current:marge(Acc, current:get_tags_twitter(Bucket1))).

top5(insta)->
	BucketList = [<<"insta_temp">>,<<"insta_1">>,<<"insta_2">>,<<"insta_3">>,<<"insta_4">>,<<"insta_5">>,<<"insta_6">>],
	All_Tags = get_all_insta(BucketList),
	Top5 = current:top5(current:sort_result(All_Tags)),
	L0 = current:find(Top5, current:get_tags_insta(<<"insta_temp">>)),
	L1 = current:find(Top5, current:get_tags_insta(<<"insta_1">>)),
	L2 = current:find(Top5, current:get_tags_insta(<<"insta_2">>)),
	L3 = current:find(Top5, current:get_tags_insta(<<"insta_3">>)),
	L4 = current:find(Top5, current:get_tags_insta(<<"insta_4">>)),
	L5 = current:find(Top5, current:get_tags_insta(<<"insta_5">>)),
	L6 = current:find(Top5, current:get_tags_insta(<<"insta_6">>)),
	combine1(Top5, L0, L1, L2, L3, L4, L5, L6);

top5(twitter)->
	BucketList = [<<"twitter_temp">>,<<"twitter_1">>,<<"twitter_2">>,<<"twitter_3">>,<<"twitter_4">>,<<"twitter_5">>,<<"twitter_6">>],
	All_Tags = get_all_twitter(BucketList),
	Top5 = current:top5(current:sort_result(All_Tags)),
	L0 = current:find(Top5, current:get_tags_twitter(<<"twitter_temp">>)),
	L1 = current:find(Top5, current:get_tags_twitter(<<"twitter_1">>)),
	L2 = current:find(Top5, current:get_tags_twitter(<<"twitter_2">>)),
	L3 = current:find(Top5, current:get_tags_twitter(<<"twitter_3">>)),
	L4 = current:find(Top5, current:get_tags_twitter(<<"twitter_4">>)),
	L5 = current:find(Top5, current:get_tags_twitter(<<"twitter_5">>)),
	L6 = current:find(Top5, current:get_tags_twitter(<<"twitter_6">>)),
	combine1(Top5, L0, L1, L2, L3, L4, L5, L6);


top5(both)->
	BucketList1 = [<<"insta_temp">>,<<"insta_1">>,<<"insta_2">>,<<"insta_3">>,<<"insta_4">>,<<"insta_5">>,<<"insta_6">>],
	BucketList2 = [<<"twitter_temp">>,<<"twitter_1">>,<<"twitter_2">>,<<"twitter_3">>,<<"twitter_4">>,<<"twitter_5">>,<<"twitter_6">>],
	All_Tags = current:marge(get_all_insta(BucketList1), get_all_twitter(BucketList2)),
	Top5 = current:top5(current:sort_result(All_Tags)),
	L0 = current:find(Top5, current:get_tags_insta(<<"insta_temp">>)),
	L1 = current:find(Top5, current:get_tags_insta(<<"insta_1">>)),
	L2 = current:find(Top5, current:get_tags_insta(<<"insta_2">>)),
	L3 = current:find(Top5, current:get_tags_insta(<<"insta_3">>)),
	L4 = current:find(Top5, current:get_tags_insta(<<"insta_4">>)),
	L5 = current:find(Top5, current:get_tags_insta(<<"insta_5">>)),
	L6 = current:find(Top5, current:get_tags_insta(<<"insta_6">>)),
	
	L00 = current:find(Top5, current:get_tags_twitter(<<"twitter_temp">>)),
	L11 = current:find(Top5, current:get_tags_twitter(<<"twitter_1">>)),
	L22 = current:find(Top5, current:get_tags_twitter(<<"twitter_2">>)),
	L33 = current:find(Top5, current:get_tags_twitter(<<"twitter_3">>)),
	L44 = current:find(Top5, current:get_tags_twitter(<<"twitter_4">>)),
	L55 = current:find(Top5, current:get_tags_twitter(<<"twitter_5">>)),
	L66 = current:find(Top5, current:get_tags_twitter(<<"twitter_6">>)),
	combine1(Top5, combine1_help(L0, L00), combine1_help(L1, L11), combine1_help(L2, L22), combine1_help(L3, L33), combine1_help(L4, L44), combine1_help(L5, L55), combine1_help(L6, L66)).

top5_result(insta)->
	Value = make_string3(top5(insta)),
	current:connect(<<"his_top5_inst">>, Value);

top5_result(twitter)->
	Value = make_string3(top5(twitter)),
	current:connect(<<"his_top5_twit">>, Value);

top5_result(both)->
	Value = make_string3(top5(both)),
	current:connect(<<"his_top5_both">>, Value).

searched(insta, Tag)->
	T0 = current:searched(current:get_tags_insta(<<"insta_temp">>), Tag),
	T1 = current:searched(current:get_tags_insta(<<"insta_1">>), Tag),
	T2 = current:searched(current:get_tags_insta(<<"insta_2">>), Tag),
	T3 = current:searched(current:get_tags_insta(<<"insta_3">>), Tag),
	T4 = current:searched(current:get_tags_insta(<<"insta_4">>), Tag),
	T5 = current:searched(current:get_tags_insta(<<"insta_5">>), Tag),
	T6 = current:searched(current:get_tags_insta(<<"insta_6">>), Tag),
	combine2(T0,T1,T2,T3,T4,T5,T6);

searched(twitter, Tag)->
	T0 = current:searched(current:get_tags_twitter(<<"twitter_temp">>), Tag),
	T1 = current:searched(current:get_tags_twitter(<<"twitter_1">>), Tag),
	T2 = current:searched(current:get_tags_twitter(<<"twitter_2">>), Tag),
	T3 = current:searched(current:get_tags_twitter(<<"twitter_3">>), Tag),
	T4 = current:searched(current:get_tags_twitter(<<"twitter_4">>), Tag),
	T5 = current:searched(current:get_tags_twitter(<<"twitter_5">>), Tag),
	T6 = current:searched(current:get_tags_twitter(<<"twitter_6">>), Tag),
	combine2(T0,T1,T2,T3,T4,T5,T6);

searched(both, Tag)->
	T0 = current:searched(current:get_tags_insta(<<"insta_temp">>), Tag),
	T1 = current:searched(current:get_tags_insta(<<"insta_1">>), Tag),
	T2 = current:searched(current:get_tags_insta(<<"insta_2">>), Tag),
	T3 = current:searched(current:get_tags_insta(<<"insta_3">>), Tag),
	T4 = current:searched(current:get_tags_insta(<<"insta_4">>), Tag),
	T5 = current:searched(current:get_tags_insta(<<"insta_5">>), Tag),
	T6 = current:searched(current:get_tags_insta(<<"insta_6">>), Tag),

	T00 = current:searched(current:get_tags_twitter(<<"twitter_temp">>), Tag),
	T11 = current:searched(current:get_tags_twitter(<<"twitter_1">>), Tag),
	T22 = current:searched(current:get_tags_twitter(<<"twitter_2">>), Tag),
	T33 = current:searched(current:get_tags_twitter(<<"twitter_3">>), Tag),
	T44 = current:searched(current:get_tags_twitter(<<"twitter_4">>), Tag),
	T55 = current:searched(current:get_tags_twitter(<<"twitter_5">>), Tag),
	T66 = current:searched(current:get_tags_twitter(<<"twitter_6">>), Tag),
	combine2(combine2_help(T0,T00), combine2_help(T1,T11), combine2_help(T2,T22), combine2_help(T3,T33), combine2_help(T4,T44), combine2_help(T5,T55), combine2_help(T6,T66)).

searched_result(insta, Tag)->
	Value = make_string2(searched(insta, Tag));
	

searched_result(twitter, Tag)->
	Value = make_string2(searched(twitter, Tag));
	

searched_result(both, Tag)->
	Value = make_string2(searched(both, Tag)).
	

make_string1(L)-> make_string1(L, 1, "{").
make_string1([], _, Acc)-> Acc++"}";
make_string1([H|T], 1, Acc)-> make_string1(T, 2, Acc++integer_to_list(H));
make_string1([H|T], 2, Acc)-> make_string1(T, 2, Acc++", "++integer_to_list(H)).

make_string2(L)-> make_string2(L, 1, "{").
make_string2([], _, Acc)-> Acc++"}";
make_string2([H|T], 1, Acc)-> make_string2(T, 2, Acc++current:make_string1(H));
make_string2([H|T], 2, Acc)-> make_string2(T, 2, Acc++" "++make_string1(H)).  

make_string3(L) -> make_string3(L, "").
make_string3([], Acc)-> Acc;
make_string3([H|T], Acc)-> make_string3(T, Acc++" "++make_string2(H)).

