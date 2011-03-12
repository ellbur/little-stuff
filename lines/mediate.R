
mediate = function(
	Matrix,
	Iters = 1
)
{
	NDims = ncol(Matrix)
	
	Mins = sapply(1:NDims, function(I) min(Matrix[,I]))
	Maxs = sapply(1:NDims, function(I) max(Matrix[,I]))
	
	It = 0
	while (It < Iters) {
		
		P1 = sapply(1:NDims, function(I) {
			runif(1, Mins[[I]], Maxs[[I]])
		})
		P2 = sapply(1:NDims, function(I) {
			runif(1, Mins[[I]], Maxs[[I]])
		})
		
		for (I in 1:NDims) {
			if (P1[I] > P2[I]) {
				Temp = P1[I]
				P1[I] = P2[I]
				P2[I] = Temp
			}
		}
		
		Sel = replicate(nrow(Matrix), T)
		for (I in 1:NDims) {
			Sel = ( Sel
				& (P1[I] < Matrix[,I])
				& (Matrix[,I] < P2[I]) )
		}
		Rows = (1:nrow(Matrix))[Sel]
		
		if (length(Rows) == 0) {
			next
		}
		
		SubMatrix = Matrix[Rows,,drop=F]
		
		New = sapply(1:NDims, function(I) {
			median(SubMatrix[,I])
		})
		
		PickRow = sample(Rows, 1)
		Matrix[PickRow,] = New
		
		It = It + 1
	}
	
	Matrix
}

