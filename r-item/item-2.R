
item = function(...) {
	foo = function() {
        environment()
	}

	args = process.args(as.list(substitute(list(...)))[-1L])
	formals(foo) = args
	
	foo
}
process.args = function(args) {
	arg.names = names(args)
	if (is.null(arg.names)) {
		arg.names = replicate(length(args), NULL)
	}
	
	names(args) = arg.names
	
	args
}

grab = function(src, obj=parent.frame()) {
    for (name in ls(src)) {
        (function(name) {
            if (!exists(name, obj, inh=F)) {
                cat(sprintf('Setting %s to\n', name))
                print(src[[name]])
                delayedAssign(name, src[[name]], assign.env=obj)
            }
        })(name)
    }
}

A = item(
    x =,
    y =,
    
    sum = x + y
)

B = item(
    x =,
    y =,
    
    init = grab(A(x, y))
)

b = B(2, 3)
#force(b$x)
#force(b$y)
#force(b$init)

