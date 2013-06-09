
`%is%` = function(signature, result, pos=parent.frame()) {
    do.is(substitute(signature), substitute(result), pos)
}

do.is = function(sig.expr, result.expr, pos) {
    car = sig.expr[[1]]
    if (identical(car, substitute((1))[[1]])) {
        return(do.is(sig.expr[[2]], result.expr, pos))
    }
    
    num.terms = length(sig.expr)
    num.args = num.terms - 1
    
    arg.values = lapply((1:num.terms)[-1L], function(j) {
        sig.expr[[j]]
    })
    arg.names = names(sig.expr)[2:num.terms]
    names(arg.values) = arg.names
    
    args = flip.args(arg.values)
    
	func = function() { }
	formals(func) = args
	body(func, envir=pos) = result.expr
    
    assign(as.character(car), func, pos)
}

