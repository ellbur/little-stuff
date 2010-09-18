
# http://mikelove.wordpress.com/2010/04/22/bootstrapping-time-series/

Beta.Real  = 0.85
Sigma.Real = 2.0

Time = 1:100

step.ts = function(X, Beta, Sigma) {
	Beta*X + rnorm(1, sd=Sigma)
}

gen.rep.apply = function(Func, Start, N, ...) {
	S = rep(0, N)
	S[1] = Start
	
	for (K in 2:N) {
		S[K] = Func(S[K-1], ...)
	}
	
	S
}

gen.ts = function(Beta, Sigma) {
	gen.rep.apply(step.ts, 0, length(Time), Beta=Beta, Sigma=Sigma)
}

Num.Trials = 10000
Trials = data.frame(
	Beta.Hat  = numeric(Num.Trials),
	Sigma.Hat = numeric(Num.Trials),
	Tee       = numeric(Num.Trials),
	P         = numeric(Num.Trials)
)

for (K in 1:Num.Trials) {
	Series = gen.ts(Beta.Real, Sigma.Real)

	X = Series[1:(length(Series)-1)]
	Y = Series[2:length(Series)]

	(Beta.Hat  <- sum(X*Y) / sum(X*X))
	Y.Hat     = Beta.Hat * X
	(Sigma.Hat <- sd(Y - Y.Hat))
	
	N   = length(Y)
	S   = Sigma.Hat / sqrt(sum(X^2))
	Tee = (Beta.Hat-Beta.Real)/S
	P   = pt(Tee, df=(N-1), lower.tail=T)
	
	Trials$Beta.Hat[K]  = Beta.Hat
	Trials$Sigma.Hat[K] = Sigma.Hat
	Trials$Tee[K]       = Tee
	Trials$P[K]         = P
}

CDF = ecdf(Trials$P)
Trials$P.Real = CDF(Trials$P)
