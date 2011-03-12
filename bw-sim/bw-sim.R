
do.run = function(L) {
	S = 0;
	N = 0;
	
	while (S < L) {
		S = S + runif(1);
		N = N + 1;
	}
	
	N;
}

do.runs = function(L, NN) {
	
	sapply(1:NN, function(Trial) {
		do.run(L);
	});
	
}

