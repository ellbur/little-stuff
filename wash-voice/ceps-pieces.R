
ceps.pieces = function(W) {
	Orig.Rate   = W@samp.rate
	Target.Rate = 2000
    
	if (W@stereo) {
		Vec = 0.5*W@left + 0.5*W@right
	}
	else {
		Vec = W@left
	}
	
	Vec = resamp(Vec, f=Orig.Rate, g=Target.Rate)
	
	Piece.Time = 2
	
	Piece.Samps = Piece.Time * Target.Rate
	Pieces.N = floor(length(Vec) / Piece.Samps)
	Pieces = vector('list', Pieces.N)
	
	for (I in 1:Pieces.N) {
		Piece = Vec[I:(I+Piece.Samps-1)]
		Pieces[[I]] = Piece
	}
	
	ceps = function(V) {
		log(abs(Re(fft(log(abs(fft(V))))[2:3])))
	}
	
	Ceps = t(sapply(Pieces, ceps))
	C.RA.df = as.data.frame(Ceps)
	
	C.RA.df
}

