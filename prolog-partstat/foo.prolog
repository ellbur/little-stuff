
% Particular

lambda(add, add_in, add_out).
op(with(add_in, Arg, add_out), +, X, Y) :- field(Arg, x, X), field(Arg, y, Y).

field(a, x, x).
field(a, y, y).

jump(x, 1).
jump(y, 2).

apply(b, add, a).

jump(c, pretend(b, [(x, 4)])).
jump(d, pretend(c, [(y, 7)])).
jump(e, pretend(d, [(c, 9)])).
jump(f, pretend(e, [(d, c)])).

jump(g, pretend(b, [(x, f)])).
jump(h, pretend(b, [(x, g)])).
jump(i, pretend(h, [(g, h)])).

jump(j, pretend(x, [(x, x)])).
jump(k, pretend(j, [(x, 2)])).

% General

formula(X, Y) :- jump(X, Y).
formula(X, Y) :- jump(X, Z), formula(Z, Y).

field(A, X, C) :- jump(A, B), field(B, X, C).

literal(X, X) :- integer(X).

ret(pretend(pretend(B, Reps1), Reps2), V) :-
	!,
	append(Reps1, Reps2, Reps),
	ret(pretend(B, Reps), V).

ret(pretend(B, Reps), V) :-
	pterm(B, Reps, [], D, RepsOut),
	!,
	ret(pretend(D, RepsOut), V).

ret(A, V) :- jump(A, B), ret(B, V).
ret(A, V) :- literal(A, V).
ret(A, V) :- op(A, +, B, C), ret(B, VB), ret(C, VC), V is VB + VC.
ret(A, V) :- op(A, ->, S, N), field(S, N, F), ret(F, V).
ret(A, V) :- apply(A, L, Arg),
	lambda(L, Param, Ret), ret(with(Param, Arg, Ret), V).

pterm(B, [(B, D)|Rest], SoFar, D, SoFarOut) :- !,
	append(SoFar, [(B, D)|Rest], SoFarOut).
pterm(B, [(C, D)|Rest], SoFar, X, SoFarOut) :-
	append(SoFar, [(C, D)], SoFarOn),
	pterm(B, Rest, SoFarOn, X, SoFarOut).

op(pretend(B, Reps), Op, pretend(X, Reps), pretend(Y, Reps)) :-
	op(B, Op, X, Y).

jump(pretend(B, Reps), pretend(X, Reps)) :-
	jump(B, X).

literal(pretend(B, Reps), X) :-
	literal(B, X).

apply(pretend(B, Reps), pretend(L, Reps), pretend(Arg, Reps)) :-
	apply(B, L, Arg).

lambda(pretend(L, Reps), Param, Ret) :-
	lambda(L, Param, Ret).

field(pretend(S, Reps), N, pretend(X, Reps)) :-
	field(S, N, X).

pretend(1, 2, 3, 4) :- !, fail.
