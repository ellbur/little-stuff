
struct = function(...) {
	Defs = as.list(substitute(list(...)))[-1L]
	
	foo = function() { environment() };
	formals(foo) = Defs;
	Parent = parent.frame();
	
	as.list(foo())
}

struct.df = function(...) {
	as.data.frame(struct(...))
}

define = function(...) {
	foo = function() { environment() };
	formals(foo) = as.list(substitute(list(...)))[-1L];
	Parent = parent.frame();
	
	Results = foo()
	
	for (Name in ls(Results)) (function(Name) {
		delayedAssign(assign.env=Parent, x=Name, value=Results[[Name]])
	}) (Name=Name)
} 

