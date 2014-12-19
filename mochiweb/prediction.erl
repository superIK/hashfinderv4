-module(prediction).
-compile(export_all).

mean(L)-> lists:sum(L)/erlang:length(L).

sum_sq_dev(L)-> sum_sq_dev(L, mean(L), 0).
sum_sq_dev([], _, Acc)-> Acc;
sum_sq_dev([H|T], Mean, Acc)-> sum_sq_dev(T, Mean, Acc+(H-Mean)*(H-Mean)).

varience(L)-> sum_sq_dev(L)/erlang:length(L).

std_dev(L)-> math:sqrt(varience(L)).

sum_sq_dev_x(L)-> sum_sq_dev_x(L, mean(L), 0).
sum_sq_dev_x([], _, Acc)-> Acc;
sum_sq_dev_x([H|T], X, Acc)-> sum_sq_dev_x(T, X, Acc+((X-H)*(X-H))).

sum_dev_xy(L1, L2)-> sum_dev_xy(L1, L2, mean(L1), mean(L2), 0).
sum_dev_xy([], [], _, _, Acc)-> Acc;
sum_dev_xy([H1|T1], [H2|T2], X, Y, Acc)-> sum_dev_xy(T1, T2, X, Y, Acc+((X-H1)*(Y-H2))).

correlation(L1, L2)-> sum_dev_xy(L1, L2)/math:sqrt(sum_sq_dev_x(L1)*sum_sq_dev_x(L2)).

slope_b(L1, L2)-> correlation(L1, L2)*std_dev(L2)/std_dev(L1).

intercept_a(L1, L2)-> mean(L2) - (slope_b(L1,L2)*mean(L1)).

y_value(L1, L2, X)-> (X*slope_b(L1, L2))+intercept_a(L1, L2). 

pred_val(XL, YL, PL)->pred_val(XL, YL, PL, 1, []).
pred_val(_, _, [], _, Acc)-> Acc;
pred_val(XL, YL, [H|T], N, Acc)-> pred_val(XL, YL, T, N+1, Acc++[{N, round(y_value(XL, YL, H))}]).


have_relation(L1, L2)->
	T_critical = 0.727,
	Correlation = correlation(L1, L2),
	T_value = Correlation*math:sqrt(erlang:length(L1)-2)/math:sqrt(1-(Correlation*Correlation)),
	case T_value>=0 of
		true-> T_value>T_critical;
		false-> (T_value*(-1))> T_critical
	end.
	
	

pred_eval(L)-> pred_eval(L, []).
pred_eval([], Acc)-> Acc;
pred_eval([[[Tag, _],L]|T], Acc)->
	case have_relation([0,1,2,3,4,5,6], lists:reverse(L)) of
		false-> pred_eval(T, Acc++[{Tag, [{"prediction not possible"}]}]);
		true-> pred_eval(T, Acc++[{Tag, pred_val([0,1,2,3,4,5,6], lists:reverse(L), [7,8,9])}])
	end.

pred_eval2()->ok.

top5_result(insta)->
	Value = make_string3(pred_eval(history:top5(insta))),
	current:connect(<<"pre_top5_inst">>, Value);

top5_result(twitter)->
	Value = make_string3(pred_eval(history:top5(twitter))),
	current:connect(<<"pre_top5_twit">>, Value);

top5_result(both)->
	Value = make_string3(pred_eval(history:top5(both))),
	current:connect(<<"pre_top5_both">>, Value).

searched_result(insta, Tag)->
	Value = make_string3(pred_eval([history:searched(insta, Tag)]));

searched_result(twitter, Tag)->
	Value = make_string3(pred_eval([history:searched(twitter, Tag)]));

searched_result(both, Tag)->
	Value = make_string3(pred_eval([history:searched(both, Tag)])).


make_string1({X})-> X;
make_string1({A, B})-> integer_to_list(B).

make_string2(L)-> make_string2(L, 1, "{").
make_string2([], _, Acc)-> Acc++"}";
make_string2([H|T], 1, Acc)-> make_string2(T, 2, Acc++make_string1(H));
make_string2([H|T], 2, Acc)-> make_string2(T, 2, Acc++", "++make_string1(H)).

make_string3(L)-> make_string3(L, "{").
make_string3([], Acc)-> Acc++"}";
make_string3([{Tag, L}|T], Acc)-> make_string3(T, Acc++" "++("{"++Tag++" "++make_string2(L)++"}")).





