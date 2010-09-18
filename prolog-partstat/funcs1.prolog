
% Get

apply(spec(X,[with(get(N))|XMods]), id, Ym) :-
	field(spec(X,XMods), N, Ym).

ret(spec(X, [with(get(N))|M]), V) :-
	field(spec(X,M), dyn(N), spec(0,[])),
	ret(spec(X, M), XV),
	get_assoc(N, XV, V).

field(spec(X, [with(get(N))|M]), parent, spec(X,M)).

% Sum

ret(
		spec(Arg, [with(sum)|ArgMods]),
		V
	) :-
	
	UnBox = spec(Arg, ArgMods),
	
	field(UnBox, x, Xm),
	field(UnBox, y, Ym),
	
    ret(Xm, XV),
    ret(Ym, YV),
    
    V is XV + YV.

% EList

ret(
		spec(Arg, [with(elist)|M]),
		V
	) :-
	empty_assoc(V).

% Add(Name)

apply(spec((st,add(Name),X,M), M), get(st), spec(X,M)).
apply(spec((va,add(Name),X,M), M), get(va), spec(X,M)).

ret(
		spec(X, [with(add(Name))|M]),
		V
	) :-
	ret(spec((st,add(Name),X,M),M), Struct),
	ret(spec((va,add(Name),X,M),M), Value),
	
	put_assoc(Name, Struct, Value, V).

field(spec(X, [with(add(N))|M]), dyn(N), spec(0,[])).
field(spec(X, [with(add(N))|M]), dyn(N2), spec(0,[])) :-
	field(spec(X,M), dyn(N2), spec(0,[])).
