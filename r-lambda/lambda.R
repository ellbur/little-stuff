
lam = function(...) {
	args = as.list(substitute(list(...)))[-1L]
	args = flip.args(args)
	class(args) = 'lambda'
	args
}

λ = lam

`%=%.lambda` = function(l.params, l.body) {
	func = function() { }
	formals(func) = l.params
	body(func, envir=parent.frame()) = substitute(l.body)
	
	func
}

