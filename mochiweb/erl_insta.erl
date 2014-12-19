-module(erl_insta).
-compile(export_all).



start(Pid) ->

ssl:start(),
application:start(inets),
retrieve(Pid).

retrieve(Pid) -> retrieve(Pid, 0).
retrieve(Pid, 18) -> ok;
retrieve(Pid, Counter) ->

  X = httpc:request(get, {"https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=1549208576.dd99346.d7f8f2f6b0964562ad7330b662bdfdbf", []},[], []),
  case X of 
    {ok,{_,_,JSON}}->
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

      connect(Final_List, Pid);

    _-> retrieve(Pid, Counter)
  end,
  io:format("loop working"), 
  timer:sleep(10000),
  retrieve(Pid, Counter+1).

connect(List, Pid) ->
  store_data(List, Pid),
  stored.

store_data([],_Pid) -> all_saved;
store_data([H|T],Pid) -> store_key_val(H,Pid), store_data(T,Pid).

store_key_val(Tuple, Pid) ->
  case is_convertable(element(2,Tuple)) of
    false-> ignore;
    _->

      riakc_pb_socket:put(Pid, riakc_obj:new(<<"insta_temp">>, 
  unicode:characters_to_binary(element(1,Tuple)), list_to_binary(unicode:characters_to_list(element(2,Tuple))))),
      stored
  end.


helper_remove_commas({Id, L}) -> helper_remove_commas (L, {Id, ""}).
helper_remove_commas([], Acc) -> Acc;
helper_remove_commas([H|T], {Id, Acc}) -> helper_remove_commas(T, {Id, H ++ " " ++ Acc}).

remove_commas(L) -> remove_commas(L, []).
remove_commas([], Acc) -> Acc;
remove_commas([H|T], Acc) -> remove_commas(T, Acc++[helper_remove_commas(H)]).


final_list(List) -> final_list(List,[]).
final_list([],Acc) -> Acc;
final_list([[{"tags",{array,L}},{"id",V}]|T],Acc) -> final_list(T, Acc ++ [{V,L}]).


is_convertable(X)->
  try
    Y = list_to_binary(X),
    true
  catch
    error:badarg-> false
  end.



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







