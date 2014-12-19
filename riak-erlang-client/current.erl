-module(current).
-compile(export_all).

quicksort([]) -> [];
quicksort([{X, Pivot}|Rest]) ->
        {Smaller, Larger} = partition(Pivot,Rest,[],[]),
        quicksort(Smaller) ++ [{X, Pivot}] ++ quicksort(Larger).


partition(_,[], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [{X, V}|T], Smaller, Larger) ->
        if V =< Pivot -> partition(Pivot, T, [{X, V}|Smaller], Larger);
        V >  Pivot -> partition(Pivot, T, Smaller, [{X, V}|Larger])
        end.

sort_result(L) -> lists:reverse(quicksort(L)).

top5(L) -> top5(L, [], 0).
top5([], Acc, _) -> Acc;
top5(_, Acc, 5) -> Acc;
top5([H|T], Acc, N) -> top5(T, Acc ++[H], N+1).


len([]) -> 0;
len([_|T]) -> 1 + len(T).

get_tags_insta(Bucket) ->
        L1 = riak_mapred_basic:start(Bucket),
        L2 = sort_result(L1),
        case len(L2) of
        0 -> [];
        1 -> [];
        _ -> [_|Rest] = L2, Rest
        end.

get_tags_twitter(Bucket) ->
        L1 = riak_mapred_basic:start(Bucket),
        L2 = sort_result(L1),
        case len(L2) of
        0 -> [];
        1 -> [];
        2 -> [];
        3 -> [];
        _ -> [_, _, _|Rest] = L2, Rest
        end.
get_tags_both(Bucket1, Bucket2) ->
        marge(get_tags_insta(Bucket1), get_tags_twitter(Bucket2)).


match1(Tuple, []) -> Tuple;
match1({X, N}, [{X, M}|_]) -> {X, N+M};
match1({X, N}, [{X, N}|_]) -> {X, N+N};
match1({X, N}, [{_, _}|T]) -> match1({X, N}, T).

match2(Tuple, L) -> match2(Tuple, L, L).
match2(_, [], Acc) -> Acc;
match2({X, _}, [{X, M}|_], Acc) -> Acc--[{X, M}];
match2({X, N}, [{_, _}|T], Acc) -> match2({X, N}, T, Acc).

is_match(_, []) -> false;
is_match({X, _}, [{X, _}|_]) -> true;
is_match({X, N}, [{_, _}|T]) -> is_match({X, N}, T).


marge(L1, L2) -> marge(L1, L2, []).
marge([], [], Acc) -> Acc;
marge([], L, Acc) -> Acc++L;
marge(L, [], Acc) -> Acc ++ L;
marge([H|T], L, Acc) ->
        B = is_match(H, L),
        case B of
                true -> marge(T, match2(H, L), Acc++[match1(H, L)]);
                false -> marge(T, L, Acc++[H])
        end.


num_of_a_tag(_, []) -> 0;
num_of_a_tag(Tag, [{Tag, N}|_]) -> N;
num_of_a_tag(Tag, [_|T]) -> num_of_a_tag(Tag, T).

find(L1, L2)->find(L1, L2, []).
find([], _, Acc) -> Acc;
find([{Tag, _}|T], L2, Acc)-> find(T, L2, Acc++[num_of_a_tag(Tag, L2)]).

combine(L1, L2, L3) -> combine(L1, L2, L3, []).
combine([], _, _, Acc) -> Acc;
combine([{Tag,N}|T], [H1|T1], [H2|T2], Acc) -> combine(T,T1,T2, Acc++[[Tag,N,H1,H2]]).

top5_result(insta) ->
        Value = make_string2(tup_list2(top5(sort_result(get_tags_insta(<<"insta_temp">>))))),
        connect(<<"cur_top5_inst">>, Value);

top5_result(twitter) ->
        Value = make_string2(tup_list2(top5(sort_result(get_tags_twitter(<<"twitter_temp">>))))),
        connect(<<"cur_top5_twit">>, Value);

top5_result(both) ->
        L1 = get_tags_insta(<<"insta_temp">>),
        L2 = get_tags_twitter(<<"twitter_temp">>),
        L = marge(L1, L2),
        Top5 = top5(sort_result(L)),
        L3 = find(Top5, L1),
        L4 = find(Top5, L2),
        Value = make_string2(combine(Top5, L3, L4)),
        connect(<<"cur_top5_both">>, Value).

searched([], Tag) -> {Tag, 0};
searched([{Tag, N}|_], Tag) -> {Tag, N};
searched([_|T], Tag) -> searched(T, Tag).
searched_result(insta, Tag)->
        Tuple = searched(get_tags_insta(<<"insta_temp">>), Tag),
        Value = make_string1(erlang:tuple_to_list(Tuple));
searched_result(twitter, Tag)->
        Tuple = searched(get_tags_twitter(<<"twitter_temp">>), Tag),
        Value = make_string1(erlang:tuple_to_list(Tuple));
searched_result(both, Tag)->
        L1 = get_tags_insta(<<"insta_temp">>),
        L2 = get_tags_twitter(<<"twitter_temp">>),
        Result = [searched(get_tags_both(<<"insta_temp">>, <<"twitter_temp">>), Tag)],
        L3 = find(Result, L1),
        L4 = find(Result, L2),
        Value = make_string2(combine(Result, L3, L4)).




tup_list2(L)-> tup_list2(L, []).
tup_list2([], Acc) -> Acc;
tup_list2([H|T], Acc) -> tup_list2(T, Acc++[erlang:tuple_to_list(H)]).

make_string1(L)-> make_string1(L, 1, "{").
make_string1([], _, Acc)-> Acc++"}";
make_string1([H|T], 1, Acc)-> make_string1(T, 2, Acc++H);
make_string1([H|T], 2, Acc)-> make_string1(T, 2, Acc++", "++integer_to_list(H)).


make_string2(L) -> make_string2(L, "").
make_string2([], Acc)-> Acc;
make_string2([H|T], Acc)-> make_string2(T, Acc++" "++make_string1(H)).

connect(Key, Value) ->
{ok, Pid} = riakc_pb_socket:start("127.0.0.1", 10017),
save(Key, Value, Pid).

save(Key, Value, Pid)->
        riakc_pb_socket:put(Pid, riakc_obj:new(<<"insta_twitter">>,
        Key, unicode:characters_to_binary(Value))).

