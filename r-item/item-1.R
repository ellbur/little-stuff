
item = function(...) {
	foo = function() {
        (function() {
            E = parent.frame()

            for (i in seq_along(args)) {
                name = args.names[[i]]
                if (substr(name, 1, 1) == '.') {
                    force(E[[name]])
                }
            }
        })()
        
        environment()
	}

	args = process.args(as.list(substitute(list(...)))[-1L])
    args.names = names(args)
	formals(foo) = args
	
	foo
}

process.args = function(args) {
	arg.names = names(args)
	if (is.null(arg.names)) {
		arg.names = replicate(length(args), NULL)
	}

	for (i in seq_along(args)) {
		if (is.null(arg.names[[i]]) || arg.names[[i]] == '') {
			arg.names[[i]] = '.' %+% as.character(i)
		}
	}
	
	names(args) = arg.names
	
	args
}

grab = function(src, obj=parent.frame()) {
    for (name in ls(src)) {
        (function(name) {
            if (!exists(name, obj, inh=F)) {
                delayedAssign(name, src[[name]], assign.env=obj)
            }
        })(name)
    }
}

A = item(
    x =,
    y =,
    
    diff = x - y
)

B = item(
    x =,
    y =,
    
    grab(A(y, x)),
    
    sum = x + y
)

a = A(1, 2)
b = B(1, 2)

