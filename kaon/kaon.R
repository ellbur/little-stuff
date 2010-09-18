
Time = seq(from=0, to=120, length.out=100)

T1 = 5
T2 = 8

K1 = 1/T1
K2 = 1/T2

Frac = 0.70

Life = ( (1/K1 * exp(-K1*Time) * Frac + 1/K2 * exp(-K2*Time) * (1-Frac)) /
	( exp(-K1*Time)*Frac + exp(-K2*Time)*(1-Frac) ) )
