
clean = function(Data.Frame) {
	is.one = function(X) {
		is.atomic(X) && (length(X) == 1)
	}
	
	is.good = function(Col) {
		all(sapply(Col, is.one))
	}
	
	for (Col.Name in colnames(Data.Frame)) {
		Col = Data.Frame[[Col.Name]]
		if (is.good(Col)) {
			Data.Frame[[Col.Name]] = unlist(Col)
		}
	}
	
	Data.Frame
}

do.trials = function(N, Func) {
	clean(as.data.frame(t(sapply(1:N, Func))))
}

noattr = function(x) {
	attributes(x) = c()
	x
}
