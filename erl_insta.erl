-module(erl_insta).
-compile(export_all).



start() ->

ssl:start(),
application:start(inets),

retrieve().

retrieve () ->

{ok,{_,_,JSON}}=httpc:request(get, {"https://api.instagram.com/v1/tags/snow/media/recent?access_token=1549208576.dd99346.d7f8f2f6b0964562ad7330b662bdfdbf", []},[], []),
Data=mochijson:decode(JSON),
{struct, A}=Data,
A,

B = proplists:delete("pagination", A), 
C = proplists:delete("meta", B),
C,
[H|_T] = C,
H,
{"data", D} = H,
D,
{array, E} = D,
E,

F = [parse(X) || X <- E], F,
Parsed_List=final_list(F),
Final_List=remove_commas(Parsed_List),Final_List,

connect(Final_List).

connect(List) ->
  {ok, Pid} = riakc_pb_socket:start("127.0.0.1", 10018),
  store_data(List, Pid),
  stored.

store_data([],Pid) -> all_saved;
store_data([H|T],Pid) -> store_key_val(H,Pid), store_data(T,Pid).

store_key_val(Tuple, Pid) ->
riakc_pb_socket:put(Pid, riakc_obj:new(<<"insta_temp">>, 
	unicode:characters_to_binary(element(1,Tuple)), unicode:characters_to_binary(element(2,Tuple)))),
stored.


helper_remove_commas({Id, L}) -> helper_remove_commas (L, {Id, ""}).
helper_remove_commas([], Acc) -> Acc;
helper_remove_commas([H|T], {Id, Acc}) -> helper_remove_commas(T, {Id, H ++ " " ++ Acc}).

remove_commas(L) -> remove_commas(L, []).
remove_commas([], Acc) -> Acc;
remove_commas([H|T], Acc) -> remove_commas(T, Acc++[helper_remove_commas(H)]).


final_list(List) -> final_list(List,[]).
final_list([],Acc) -> Acc;
final_list([[{"tags",{array,L}},{"id",V}]|T],Acc) -> final_list(T, Acc ++ [{V,L}]).





parse(S) ->
{struct, List} = S,
A=proplists:delete("filter",List),
B=proplists:delete("link", A),B,
C=proplists:delete("attribution", B),
D=proplists:delete("type",C),
E=proplists:delete("comments",D),
F=proplists:delete("users_in_photo", E),
G=proplists:delete("caption",F),
H=proplists:delete("likes",G),
I=proplists:delete("images",H),
J=proplists:delete("user_has_liked",I),
K=proplists:delete("user",J),
L=proplists:delete("videos",K),
M=proplists:delete("location",L),
N=proplists:delete("created_time",M),N.






