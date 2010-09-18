
break1 = function(X) {
	do.call(c, lapply(X, function(x) { c(Re(x), Im(x)) }))
}

break2 = function(X) {
	do.call(c, lapply(X, function(x) { c(-Im(x), Re(x)) }))
}

fit.complex = function(Y, X.List) {
	
	# Split into real variables
	YF = break1(Y)
	XF.List = do.call(c, lapply(X.List,
		function(x) { list(break1(x), break2(x)) } ))
	
	# Make the data.fram
	Data = data.frame(Y = YF)
	X.Names = paste('X', 1:length(XF.List), sep='')
	
	for (N in seq_along(XF.List)) {
		Data[[ X.Names[[N]] ]] = XF.List[[N]]
	}
	
	# Formula + Model
	Formula = paste("Y ~ ", paste(X.Names, collapse='+'), "-1")
	Model = lm(as.formula(Formula), data=Data)
	
	# Make them complex again
	Coeffs = sapply(seq_along(X.List),
		function(N) {
			( Model$coefficients[[ X.Names[[2*N-1]] ]]
			+ Model$coefficients[[ X.Names[[2*N]] ]]*1i )
		})
	names(Coeffs) = names(X.List)
	
	Model$coefficients.complex = Coeffs
	
	Model
}

