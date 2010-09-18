
DX = 0.001
Xs = seq(0, 2, by=DX)
Ys = Xs

make.filter = function(N, Terms=100) {
	sapply(seq(0, Terms-1, by=1), function(K) {
		choose(N, K) * (-1)^K / DX^N
	});
}

make.deriv = function(N) {
	filter(Ys, make.filter(N));
}


