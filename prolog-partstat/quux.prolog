
:- load_files('base1.prolog', []), load_files('funcs1.prolog', []).

cfield(spec(a,[]), x, spec(1,[])).
apply(spec(b,[]), id, spec(a,[])).

apply(spec(c,[]), get(x), spec(b,[])).
apply(spec(d,[]), id, spec(c, [pretend(w,w)])).
apply(spec(e,[]), id, spec(c, [pretend(a,1)])).
