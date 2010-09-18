
n.plus.cross = function(Sig, Level) {
	Sig = na.omit(Sig)
	Where = sign(Sig - Level)
	Where[Where == 0] = -1
	
	sum(diff(Where) == 2)
}

cross.spectrum = function(Sig) {
	Levels = seq(from=min(Sig), to=max(Sig), len=1000)
	Crosses = sapply(Levels, function(Level) n.plus.cross(Sig, Level))
	
	data.frame(Level = Levels, Crosses = Crosses)
}

half = function(Sig) {
	sapply(1:(length(Sig)/2), function(N) mean(c(Sig[2*N-1], Sig[2*N])))
}

half.spectrum = function(Sig) {
	Crosses = c()
	Halves  = c(1)
	
	I = 1
	
	while (length(Sig) > 1) {
		Level = quantile(Sig, 0.75)
		Crosses[I] = n.plus.cross(Sig, Level)
		Halves[I]  = I - 1
		
		Sig = half(Sig)
		I = I + 1
	}
	
	data.frame(Halves, Crosses)
}

smudge.spectrum = function(Sig) {
	Crosses = c()
	Smudges = c()
	
	I = 1
	
	while (I < 1000) {
		Level = quantile(Sig, 0.75, na.rm=T)
		Crosses[I] = n.plus.cross(Sig, Level)
		Smudges[I] = I
		
		Sig = filter(Sig, c(0.5, 0.5))
		I = I + 1
	}
	
	data.frame(Crosses, Smudges)
}
