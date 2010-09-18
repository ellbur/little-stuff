
R1 = 0
R2 = 0
C  = 0

K  = -R2/R1
Wc = 1/(R2*C)
R1 = 4.7e+3
R2 = 4.7e+3
C  = 0.05e-9

Ckt = (function(
	K  = -R2/R1,
	Wc = 1/(R2*C),
	R1 = 4.7e+3,
	R2 = 4.7e+3,
	C  = 0.05e-9
) environment())

define1 = function(Defs) {
	foo = function() { environment() };
	formals(foo) = Defs;
	Parent = parent.frame();
	
	Results = foo()
	
	for (Name in ls(Results)) {
		Parent[[Name]] = Results[[Name]]
	}
}

define = define1
define(alist(
	K  = -R2/R1,
	Wc = 1/(R2*C),
	R1 = 4.7e+3,
	R2 = 4.7e+3,
	C  = 0.05e-9
))

define2 = function(Defs) {
	foo = function() { environment() };
	formals(foo) = Defs;
	Parent = parent.frame();
	
	Results = foo()
	
	for (Name in ls(Results)) {
		delayedAssign(assign.env=Parent, x=Name, value=Results[[Name]])
	}
}
define = define2
define(alist(
	K  = -R2/R1,
	Wc = 1/(R2*C),
	R1 = 4.7e+3,
	R2 = 4.7e+3,
	C  = 0.05e-9
))
print(K)
print(Wc)
print(R1)
print(R2)
print(C)

define3 = function(Defs) {
	foo = function() { environment() };
	formals(foo) = Defs;
	Parent = parent.frame();
	
	Results = foo()
	
	for (Name in ls(Results)) (function(Name) {
		delayedAssign(assign.env=Parent, x=Name, value=Results[[Name]])
	}) (Name=Name)
}
