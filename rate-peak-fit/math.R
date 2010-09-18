
mabs = function(Point, Mu, Sigma) {
	S = Sigma
	U = Mu
	C = Point
	
	if (U < C) {
		U = C + (C - U)
	}
	
	(
		sqrt(2/pi) * S * exp( -(U-C)^2 / (2*S^2) )
		
		+ 2*(C-U)*pnorm((C-U)/S) + U - C
	)
}

max.abs.normal.cdf = function(U, S) {

# This is rather approximate
	
	r(AU, S) %=% max.abs.normal.filter(U, S)
	
	function(X) {
		prod(sapply(1:length(AU), function(II) {
			pnorm(X, mean=AU[[II]], sd=S[[II]])
		}))
	}
}

max.abs.normal.pdf = function(U, S) {
	r(AU, S) %=% max.abs.normal.filter(U, S)
	
	function(X) {
		( prod(sapply(1:length(AU), function(II) {
			pnorm(X, mean=AU[[II]], sd=S[[II]])
		}))
		
		* sum(sapply(1:length(AU), function(II) {
			( dnorm(X, mean=AU[[II]], sd=S[[II]]) /
			  pnorm(X, mean=AU[[II]], sd=S[[II]])
			)
		}))
		)
	}
}

max.abs.normal.filter = function(U, S) {
	AU = abs(U)
	Max = max(AU)
	Max.S = S[[which.max(AU)]]
	
	Z = (Max-AU) / sqrt(Max.S^2 + S^2)
	Select = Z < 4
	
	AU = AU[Select]
	 S =  S[Select]
	
	list(AU, S)
}

quick.mean = function(Start, Cum, Den, N=5) {
	Up.X = numeric(N)
	Up.P = numeric(N)
	
	Dn.X = numeric(N)
	Dn.P = numeric(N)
	
	Up.X[[1]] = Start
	Up.P[[1]] = Cum(Start)
	
	Dn.X[[1]] = Up.X[[1]]
	Dn.P[[1]] = Up.P[[1]]
	
	for (II in 2:N) {
		Up.X[[II]] = quick.mean.up(Up.X[[II-1]], Up.P[[II-1]], Den)
		Up.P[[II]] = Cum(Up.X[[II]])
		
		Dn.X[[II]] = quick.mean.dn(Dn.X[[II-1]], Dn.P[[II-1]], Den)
		Dn.P[[II]] = Cum(Dn.P[[II]])
	}
	
	X = c(rev(Dn.X), Up.X[2:N])
	P = c(rev(Dn.P), Up.P[2:N])
	
	MX = (X[2:(2*N-1)] + X[1:(2*N-2)]) / 2
	DP = diff(P)
	
	Mean = sum(MX * DP) / sum(DP)
	
	Mean
}

quick.mean.up = function(X.Start, P.Start, Den) {
	P.Target = 1-(1-P.Start)/2
	
	A = P.Target-P.Start
	B = Den(X.Start)
	
	if (A/B < 1e-8 || B/A < 1e-8) {
		X.Start
	}
	
	X.Start + A/B
}

quick.mean.dn = function(X.Start, P.Start, Den) {
	P.Target = P.Start/2
	
	A = P.Target-P.Start
	B = Den(X.Start)
	
	if (A/B < 1e-8 || B/A < 1e-8) {
		X.Start
	}
	
	X.Start + A/B
}
