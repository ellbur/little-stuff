
clean = function(Data.Frame) {
	is.one = function(X) {
		is.atomic(X) && (length(X) == 1)
	}
	
	is.good = function(Col) {
		all(sapply(Col, is.one))
	}
	
	lapply(Data.Frame, function(Col) {
		Col
	})
}
