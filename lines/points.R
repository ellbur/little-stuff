
source('scale.R')

get.points = function(Matrix, Size=20, Quant=0.9) {
	
	Full.Matrix = Matrix
	
	Full.Matrix = Full.Matrix - min(Full.Matrix)
	Full.Matrix = Full.Matrix / max(Full.Matrix)
	
	Matrix = reduce.image.wh(Full.Matrix, Size, Size)
	
	col.to.x = function(Col) {
		(Col - 1) / ncol(Matrix) * ncol(Full.Matrix) + 1
	}
	
	row.to.y = function(Row) {
		(Row - 1) / nrow(Matrix) * nrow(Full.Matrix) + 1
	}
	
	Cutoff = quantile(c(Matrix), Quant)
	
	Points = do.call(c, lapply(1:ncol(Matrix), function(C)
		lapply(1:nrow(Matrix), function(R) c(R,C) ) ))
	
	Points = Filter(x=Points, f = function(P) {
		Matrix[ P[[1]], P[[2]] ] > Cutoff
	})
	
	Points = lapply(Points, function(P) {
		c(
			x = col.to.x(P[[2]]),
			y = row.to.y(P[[1]])
		)
	})
	;
	
	Points
}

