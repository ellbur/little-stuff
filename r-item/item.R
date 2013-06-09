
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
			
			if (exists('.class', E)) {
				class(E) = c(E$.class, 'item')
			}
			else {
				class(E) = 'item'
			}
			
			E
		})()
	};
	args = process.args(as.list(substitute(list(...)))[-1L])
	args.names = names(args)
	
	formals(foo) = args
	
	foo
}

make.get.set = function(x, obj=parent.frame()) {
	name = as.character(substitute(x))
	
	obj[['get.' %+% name]] = function() {
		obj[[name]]
	}
	obj[['set.' %+% name]] = function(new.x) {
		obj[[name]] = new.x
	}
}

set.class = function(class.name, obj=parent.frame()) {
	obj$.class = class.name
}

print.item = function(item) {
	print(as.list(item))
}

as.list.item = function(item) {
	as.list.environment(item)
}

