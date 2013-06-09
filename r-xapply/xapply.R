
xapply = function(
	seq,
	ex,
	cb = substitute(ex),
	var = 'x',
	mapper = lapply,
	parent = parent.frame()
)
{
	foo = function(.var, .loop.var, .cb) {
		assign(.var, .loop.var)
		eval(.cb)
	}
	environment(foo) = parent
	mapper(seq, foo, .var=var, .cb=cb)
}

xsapply = function(
	seq,
	ex,
	cb = substitute(ex),
	var = 'x',
	mapper = sapply,
	parent = parent.frame()
)
{
	xapply(seq, ex, cb, var, mapper, parent)
}

yapply = function(
	seq,
	ex,
	cb = substitute(ex),
	var = 'y',
	mapper = lapply,
	parent = parent.frame()
)
{
	xapply(seq, ex, cb, var, mapper, parent)
}

ysapply = function(
	seq,
	ex,
	cb = substitute(ex),
	var = 'y',
	mapper = sapply,
	parent = parent.frame()
)
{
	xapply(seq, ex, cb, var, mapper, parent)
}

