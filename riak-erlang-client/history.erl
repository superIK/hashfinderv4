-module(history).
 -compile(export_all).

 combine1(L, L1, L2, L3, L4, L5, L6) -> combine1(L, L1, L2, L3, L4, L5, L6, []).
 combine1([], _, _, _, _, _, _, Acc) -> Acc; 
combine1([{Tag,N}|T],[H1|T1],[H2|T2],[H3|T3],[H4|T4],[H5|T5],[H6|T6],Acc) ->
	combine1(T,T1,T2,T3,T4,T5,T6, Acc++[[[Tag,N], [H1, H2, H3, H4, H5, H6]]]).
 combine2(L, L1, L2, L3, L4, L5, L6) -> combine2(L, L1, L2, L3, L4, L5, L6, []).
 combine2([], _, _, _, _, _, _, Acc) -> Acc;
 combine2([[X,Y]|T], [H1|T1], [H2|T2], [H3|T3], [H4|T4], [H5|T5], [H6|T6], Acc) ->
	combine2(T,T1,T2,T3,T4,T5,T6, Acc++[[X, Y, [H1, H2, H3, H4, H5, H6]]]).


 combine3(T1,T2,T3,T4,T5,T6) -> [{element(1,T1), element(2,T1)+element(2,T3)+element(2,T4) +element(2,T5)+element(2,T6)}, {element(2,T1), element(2,T2),element(2,T3), element(2,T4),element(2,T5),element(2,T6)}].

 combine4([X,Y], T1,T2,T3,T4,T5,T6) -> [{element(1,X), element(2,X)+element(2,T1)+element(2,T3)+element(2,T4) +element(2,T5)+element(2,T6)}, Y, {element(2,T1), element(2,T2),element(2,T3), element(2,T4),element(2,T5),element(2,T6)}]. 
get_all_insta(BucketList) -> get_all_insta(BucketList, []).
 get_all_insta([], Acc) -> Acc; 
get_all_insta([Bucket1|Rest], Acc) ->
	get_all_insta(Rest, current:marge(Acc, current:get_tags_insta(Bucket1))).

 get_all_twitter(BucketList) -> get_all_twitter(BucketList, []).
 get_all_twitter([], Acc) -> Acc; 
get_all_twitter([Bucket1|Rest], Acc) ->
	get_all_twitter(Rest, current:marge(Acc, current:get_tags_twitter(Bucket1))).

 top5_result(insta)->
	BucketList = [<<"insta_1">>,<<"insta_2">>,<<"insta_3">>,<<"insta_4">>,<<"insta_5">>,<<"insta_6">>],
	All_Tags = get_all_insta(BucketList),
	Top5 = current:top5(current:sort_result(All_Tags)),
	L1 = current:find(Top5, current:get_tags_insta(<<"insta_1">>)),
	L2 = current:find(Top5, current:get_tags_insta(<<"insta_2">>)),
	L3 = current:find(Top5, current:get_tags_insta(<<"insta_3">>)),
	L4 = current:find(Top5, current:get_tags_insta(<<"insta_4">>)),
	L5 = current:find(Top5, current:get_tags_insta(<<"insta_5">>)),
	L6 = current:find(Top5, current:get_tags_insta(<<"insta_6">>)),
	Value = make_string3(combine1(Top5, L1, L2, L3, L4, L5, L6)),
	current:connect(<<"his_top5_inst">>, Value); top5_result(twitter)->
	BucketList = [<<"twitter_1">>,<<"twitter_2">>,<<"twitter_3">>,<<"twitter_4">>,<<"twitter_5">>,<<"twitter_6">>],
	All_Tags = get_all_twitter(BucketList),
	Top5 = current:top5(current:sort_result(All_Tags)),
	L1 = current:find(Top5, current:get_tags_twitter(<<"twitter_1">>)),
	L2 = current:find(Top5, current:get_tags_twitter(<<"twitter_2">>)),
	L3 = current:find(Top5, current:get_tags_twitter(<<"twitter_3">>)),
	L4 = current:find(Top5, current:get_tags_twitter(<<"twitter_4">>)),
	L5 = current:find(Top5, current:get_tags_twitter(<<"twitter_5">>)),
	L6 = current:find(Top5, current:get_tags_twitter(<<"twitter_6">>)),
	Value= make_string3(combine1(Top5, L1, L2, L3, L4, L5, L6)),
	current:connect(<<"his_top5_twit">>, Value); top5_result(both)->
	BucketList1 = [<<"insta_1">>,<<"insta_2">>,<<"insta_3">>,<<"insta_4">>,<<"insta_5">>,<<"insta_6">>],
	BucketList2 = [<<"twitter_1">>,<<"twitter_2">>,<<"twitter_3">>,<<"twitter_4">>,<<"twitter_5">>,<<"twitter_6">>],
	All_Tags = current:marge(get_all_insta(BucketList1), get_all_twitter(BucketList2)),
	Top5 = current:top5(current:sort_result(All_Tags)),
	L1 = current:find(Top5, current:get_tags_insta(<<"insta_1">>)),
	L2 = current:find(Top5, current:get_tags_insta(<<"insta_2">>)),
	L3 = current:find(Top5, current:get_tags_insta(<<"insta_3">>)),
	L4 = current:find(Top5, current:get_tags_insta(<<"insta_4">>)),
	L5 = current:find(Top5, current:get_tags_insta(<<"insta_5">>)),
	L6 = current:find(Top5, current:get_tags_insta(<<"insta_6">>)),
	L= combine1(Top5, L1, L2, L3, L4, L5, L6),
	L8 = current:find(Top5, current:get_tags_twitter(<<"twitter_1">>)),
	L9 = current:find(Top5, current:get_tags_twitter(<<"twitter_2">>)),
	L10 = current:find(Top5, current:get_tags_twitter(<<"twitter_3">>)),
	L11 = current:find(Top5, current:get_tags_twitter(<<"twitter_4">>)),
	L12 = current:find(Top5, current:get_tags_twitter(<<"twitter_5">>)),
	L13 = current:find(Top5, current:get_tags_twitter(<<"twitter_6">>)),
	Value = make_string3(combine2(L, L8, L9, L10, L11, L12, L13)),
	current:connect(<<"his_top5_both">>, Value).

 searched_result(insta, Tag)->
	T1 = current:searched(current:get_tags_insta(<<"insta_1">>), Tag),
	T2 = current:searched(current:get_tags_insta(<<"insta_2">>), Tag),
	T3 = current:searched(current:get_tags_insta(<<"insta_3">>), Tag),
	T4 = current:searched(current:get_tags_insta(<<"insta_4">>), Tag),
	T5 = current:searched(current:get_tags_insta(<<"insta_5">>), Tag),
	T6 = current:searched(current:get_tags_insta(<<"insta_6">>), Tag),
	combine3(T1,T2,T3,T4,T5,T6);

 searched_result(twitter, Tag)->
	T1 = current:searched(current:get_tags_twitter(<<"twitter_1">>), Tag),
	T2 = current:searched(current:get_tags_twitter(<<"twitter_2">>), Tag),
	T3 = current:searched(current:get_tags_twitter(<<"twitter_3">>), Tag),
	T4 = current:searched(current:get_tags_twitter(<<"twitter_4">>), Tag),
	T5 = current:searched(current:get_tags_twitter(<<"twitter_5">>), Tag),
	T6 = current:searched(current:get_tags_twitter(<<"twitter_6">>), Tag),
	combine3(T1,T2,T3,T4,T5,T6);

 searched_result(both, Tag)->
	T1 = current:searched(current:get_tags_insta(<<"insta_1">>), Tag),
	T2 = current:searched(current:get_tags_insta(<<"insta_2">>), Tag),
	T3 = current:searched(current:get_tags_insta(<<"insta_3">>), Tag),
	T4 = current:searched(current:get_tags_insta(<<"insta_4">>), Tag),
	T5 = current:searched(current:get_tags_insta(<<"insta_5">>), Tag),
	T6 = current:searched(current:get_tags_insta(<<"insta_6">>), Tag),
	L = combine3(T1,T2,T3,T4,T5,T6),
	T8 = current:searched(current:get_tags_twitter(<<"twitter_1">>), Tag),
	T9 = current:searched(current:get_tags_twitter(<<"twitter_2">>), Tag),
	T10 = current:searched(current:get_tags_twitter(<<"twitter_3">>), Tag),
	T11 = current:searched(current:get_tags_twitter(<<"twitter_4">>), Tag),
	T12 = current:searched(current:get_tags_twitter(<<"twitter_5">>), Tag),
	T13 = current:searched(current:get_tags_twitter(<<"twitter_6">>), Tag),
combine4(L, T8,T9,T10,T11,T12,T13).

 make_string1(L)-> make_string1(L, 1, "{"). make_string1([], _, Acc)-> Acc++"}"; make_string1([H|T], 1, Acc)-> make_string1(T, 2, Acc++integer_to_list(H));

 make_string1([H|T], 2, Acc)-> make_string1(T, 2, Acc++", "++integer_to_list(H)). make_string2(L)-> make_string2(L, 1, "{").

 make_string2([], _, Acc)-> 
Acc++"}";
 make_string2([H|T], 1, Acc)-> make_string2(T, 2, Acc++current:make_string1(H));

 make_string2([H|T], 2, Acc)-> make_string2(T, 2, Acc++" "++make_string1(H)). 
make_string3(L) -> make_string3(L, ""). make_string3([], Acc)-> Acc;
 make_string3([H|T], Acc)-> make_string3(T, Acc++" "++make_string2(H)).
