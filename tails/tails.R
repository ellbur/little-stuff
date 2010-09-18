
X = seq(from=0, to=200, by=1)

U1 = 100
S1 =  20

U2 = 105
S2 =  20

U3 = 130
S3 =  5

TU1 = (U1*S3^2 + U3*S1^2) / (S1^2 + S3^2)
TU2 = (U2*S3^2 + U3*S2^2) / (S2^2 + S3^2)

TA1 = exp( -(U1-U3)^2/(2*(S1^2+S3^2)) ) / sqrt(S1^2+S3^2)
TA2 = exp( -(U2-U3)^2/(2*(S2^2+S3^2)) ) / sqrt(S2^2+S3^2)

plot.dist = function(...) {
	C1 = dnorm(X, U1, S1)
	C2 = dnorm(X, U2, S2)
	C3 = dnorm(X, U3, S3)
	
	C1 = C1 / max(C1)
	C2 = C2 / max(C2)
	C3 = C3 / max(C3)
	
	Curves = list(
		C1,
		C2,
		C3,
		
		C1 * C3,
		C2 * C3
	)
	
	plot(c(), c(), xlim=range(X), ylim=range(do.call(c, Curves)))
	
	lines(X, Curves[[1]], col='red',   lwd=2)
	lines(X, Curves[[2]], col='blue',  lwd=2)
	lines(X, Curves[[3]], col='black', lwd=2)
	
	lines(X, Curves[[4]], col='red',   lty=3)
	lines(X, Curves[[5]], col='blue',  lty=3)
}
