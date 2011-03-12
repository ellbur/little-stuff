
# http://cran.r-project.org/doc/contrib/R-and-octave.txt

meshgrid = function(X, Y) {
	list(
		XX = outer(Y*0, X, FUN='+'),
		YY = outer(Y, X*0, FUN='+')
	)
}

