
`%=%.def` = function(d.params, d.body) {
	func = function() { }
	formals(func) = d.params
	body(func, envir=parent.frame()) = substitute(d.body)
	
	assign(attr(d.params, 'name'), func, pos=parent.frame())
}

def = function(name, ...) {
	args = as.list(substitute(list(...)))[-1L]
	args = flip.args(args)
	
	class(args) = 'def'
	attr(args, 'name') = as.character(substitute(name))
	
	args
}

flip.args = function(args) {
	arg.names = names(args)
	if (is.null(arg.names)) {
		arg.names = replicate(length(args), NULL)
	}
	
	for (i in seq_along(args)) {
		if (is.null(arg.names[[i]]) || arg.names[[i]] == '') {
			arg.names[[i]] = as.character(args[[i]])
			args[[i]] = alist(x=)[['x']]
		}
		if (arg.names[[i]] == '..') {
			arg.names[[i]] = '...'
		}
	}
	
	names(args) = arg.names
	
	args
}

