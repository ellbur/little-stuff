
Start = 0
Stop  = 1

Func = function(x) {
	x^2
}

integrate.trap = function(Func, Start, Stop, NPoint) {
	Ks = 0:(NPoint-1)
	Xs = Start + (Stop - Start)*Ks/(NPoint-1)
	Fs = sapply(Xs, Func)
	Coeffs = sapply(Ks, function(K) {
		if (K == 0 || K == NPoint-1) 0.5
		else 1
	})
	
	sum(Coeffs * (Stop-Start)/(NPoint-1) * Fs)
}

integrate.mc = function(Func, Start, Stop, NPoint) {
	Xs = runif(NPoint, Start, Stop)
	Fs = sapply(Xs, Func)
	
	sum(Fs * (Stop-Start)/NPoint)
}

integrate.mc.strat = function(Func, Start, Stop, NPoint) {
	Ks = 0:(NPoint-1)
	Delta = (Stop-Start)/NPoint
	Xs = sapply(Ks, function(K) {
		runif(1, Start + Delta*K, Start + Delta*(K+1))
	})
	Fs = sapply(Xs, Func)
	
	sum(Fs * (Stop-Start)/NPoint)
}
