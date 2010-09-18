
Trig = 0:50;

A_Mean = 10;
A_Std  =  5;

B_Mean = 14;
B_Std  = 30;

A = normcdf(Trig, A_Mean, A_Std);
B = normcdf(Trig, B_Mean, B_Std);

PPRT = B ./ A.^2;

[ Best_PPRT Best_Index ] = min(PPRT);
Best_Trig = Trig(Best_Index)

plot(Trig, A, Trig, B, Trig, PPRT, [Best_Trig, Best_Trig], [0.01, 1.99])
axis([ 0 50 0 2])
