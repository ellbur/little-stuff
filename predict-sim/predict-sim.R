
Mu    = 1.0
Sigma = 1.0

N     = 5

# Cases
# 1) xbar < 0 && x < 0
# 2) xbar > 0 && x > 0

P.Correct = (
	pnorm(0, Mu, Sigma/sqrt(N), low=T) * pnorm(0, Mu, Sigma, low=T) +
	pnorm(0, Mu, Sigma/sqrt(N), low=F) * pnorm(0, Mu, Sigma, low=F) )

# Now simulate

Num.Trials = 1000

gen.point = function() {
	rnorm(1) * Sigma + Mu
}

clean = function(Data.Frame) {
	is.one = function(X) {
		is.atomic(X) && (length(X) == 1)
	}
	
	is.good = function(Col) {
		all(sapply(Col, is.one))
	}
	
	Cols = Filter(is.good, Data.Frame)
	as.data.frame(lapply(Cols, unlist))
}

Trials = as.data.frame(t(sapply(1:Num.Trials, function(Trial) {
	
	Xs = replicate(N, gen.point())
	X  = gen.point()
	
	Prediction = sign(sum(Xs))
	
	Ws = sign(Xs)
	Prediction.Count = sign(sum(Ws > 0) / length(Ws) - 0.5)
	
	Result     = sign(X)
	Correct = Prediction == Result
	Correct.Count = Prediction.Count == Result
	
	as.list(environment())
	
})))
	
Stats = clean(Trials)
