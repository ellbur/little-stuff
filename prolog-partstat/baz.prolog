
% Specifics

apply(spec(a,[]), id, spec(1,[])).
apply(spec(b,[]), id, spec(2,[])).

field(spec(c,[]), a, spec(a,[])).
field(spec(c,[]), b, spec(b,[])).

apply(spec(d,[]), sum2, spec(c,[])).
apply(spec(e,[]), id, spec(d,[pretend(b,5)])).

apply(spec((a,sum2,X,M), M), get(a), spec(X, M)).
apply(spec((b,sum2,X,M), M), get(b), spec(X, M)).

field(spec((s,sum2,X,M), M), x, spec((a,sum2,X,M), M)).
field(spec((s,sum2,X,M), M), y, spec((b,sum2,X,M), M)).

apply(spec((r,sum2,X,M), M), id,
	spec((s,sum2,X,M), [
		pretend((a,sum2,X,M),(b,sum2,X,M)) |
		M
	])).

apply(spec(X, [with(sum2)|M]), sum, spec((r,sum2,X,M), M)).

% Dealing with mods

spec_add(spec(Var, Mods), Mod, spec(Var, [Mod|Mods])).

% Jump

jump(Xm, spec(Y, [with(Func)|YMods])) :- apply(Xm, Func, spec(Y, YMods)).

jump(spec(X, [with(id)|XMods]), spec(X, XMods)).

% Field

field(X, N, V) :- jump(X, Y), field(Y, N, V).
field(
		spec(X, [pretend(C,D)|XMods]),
		N,
		spec(Y, [pretend(C,D)|YMods])
	) :-
	X \= C,
	field(spec(X, XMods), N, spec(Y, YMods)).

% Apply

apply(
		spec(X, [pretend(C,D)|XMods]),
		Func,
		spec(Y, [pretend(C,D)|YMods])
	) :-
	X \= C,
	apply(spec(X, XMods), Func, spec(Y, YMods)).

apply(spec(X,[]), literal, spec(V,[])) :- literal(X, V).

apply(spec(Var, [pretend(Var,D)|Mods]), id, spec(D, Mods)).

apply(spec(X,[with(get(N))|XMods]), id, Ym) :-
	field(spec(X,XMods), N, Ym).

% Literal

literal(X, X) :- integer(X).

% Ret

ret(
		spec(V, [with(literal)|VMods]),
		V,
		[spec(V, [with(literal)|VMods])]
	).
ret(Xm, V, [Xm|YL]) :- jump(Xm, Ym), ret(Ym, V, YL).

ret(
		spec(Arg, [with(sum)|ArgMods]),
		V,
		L
	) :-
	
	UnBox = spec(Arg, ArgMods),
	
	field(UnBox, x, Xm),
	field(UnBox, y, Ym),
	
    ret(Xm, XV, XL),
    ret(Ym, YV, YL),
    
    V is XV + YV,
    
    append([ [spec(Arg, [with(sum)|ArgMods])], XL, YL ], L).

