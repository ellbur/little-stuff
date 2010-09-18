
# http://mikelove.wordpress.com/2010/04/22/bootstrapping-time-series/

Beta.Real  = 0.85
Sigma.Real = 2.0

gen.data = function(X) {
	Beta.Real*X + rnorm(length(X), sd=Sigma.Real)
}

Num.Trials = 10000
Trials = data.frame(
	Beta.Hat  = numeric(Num.Trials),
	Sigma.Hat = numeric(Num.Trials),
	Tee       = numeric(Num.Trials),
	P         = numeric(Num.Trials),
	X.Mean    = numeric(Num.Trials),
	SXX       = numeric(Num.Trials)
)

N = 99

for (K in 1:Num.Trials) {
	X = rnorm(N, sd=2)
	Y = gen.data(X)

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
	Trials$X.Mean[K]    = mean(X)
	Trials$SXX[K]       = sum(X^2)
}

CDF = ecdf(Trials$P)
Trials$P.Real = CDF(Trials$P)
