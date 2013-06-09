
echo = function(X) {
	Name = deparse(substitute(X))
	cat(sprintf('%s =\n', Name))
	print(X)
}

