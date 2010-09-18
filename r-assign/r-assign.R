
'%=%' = function(l, r, ...) UseMethod('%=%')

'%=%.lbunch' = function(l, r, ...) {
	Envir = as.environment(-1)
	
	for (II in 1:length(l)) {
		do.call('<-', list(l[[II]], r[[II]]), envir=Envir)
	}
}

l = function(...) {
	List = as.list(substitute(list(...)))[-1L]
	class(List) = 'lbunch'
	
	List
}

