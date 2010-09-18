
% id

jump(X, Y) :- apply(X, id, [Y]).

% tuple

% Ugh....

% pretend

apply(s(X, [pretend(C,D),XM]), Func, YTP) :-
	apply(s(X, XM), Func, YT),
	mod_add_list(YT, pretend(C,D), YTP).

% mod_add_list

mod_add_list(
		[s(X, Xm) | RestIn],
		Mod,
		[s(X, [Mod|Xm]) | RestOut]) :-
	mod_add_list(RestIn, Mod, RestOut).
mod_add_list([], _, []).


