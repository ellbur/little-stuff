
:- multifile apply/3 .
:- multifile ret/2 .
:- multifile field/3 .
:- multifile cfield/3 .

% Jump

jump(Xm, spec(Y, [with(Func)|YMods])) :- apply(Xm, Func, spec(Y, YMods)).

jump(spec(X, [with(id)|XMods]), spec(X, XMods)).

% Field

field(X, N, V) :- cfield(X, N, V).
field(X, N, V) :- jump(X, Y), field(Y, N, V).

% CField

cfield(
		spec(X, [pretend(C,D)|XMods]),
		N,
		spec(Y, [pretend(C,D)|YMods])
	) :-
	X \= C,
	cfield(spec(X, XMods), N, spec(Y, YMods)).

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

% Literal

literal(X, X) :- integer(X).

% Ret

ret(
		spec(V, [with(literal)|VMods]),
		V
	).
ret(Xm, V) :- jump(Xm, Ym), ret(Ym, V).
