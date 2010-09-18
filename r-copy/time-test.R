
time.op = function(N, Exp) {
	Exp = parse(text=Exp)
	M = numeric(N)
	
	N.Trials = 10
	Times = numeric(N.Trials)
	
	for (II in 1:N.Trials) {
		Times[[II]] = system.time(eval(Exp))[['elapsed']]
	}
	
	mean(Times)
}

time.test = function(Exp) {
	Ns = 10^(1:6)
	Times = sapply(Ns, time.op, Exp=Exp)
	
	data.frame(Ns, Times)
}
