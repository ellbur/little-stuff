
:- load_files('base1.prolog', []), load_files('funcs1.prolog', []).

apply(spec(x,[]), id, spec(2,[])).

apply(spec(a,[]), elist, spec(0,[])).

cfield(spec(b,[]), st, spec(a,[])).
cfield(spec(b,[]), va, spec(x,[])).

apply(spec(c,[]), add(huh), spec(b,[])).

apply(spec(d,[]), get(huh), spec(c,[])).

apply(spec(e,[]), id, spec(d,[pretend(x,3)])).
apply(spec(f,[]), id, spec(d,[pretend(c,a)])).
apply(spec(g,[]), get(huh), spec(a,[])).

apply(spec(h,[]), get(parent), spec(d,[])).
apply(spec(i,[]), get(parent), spec(e,[])).
