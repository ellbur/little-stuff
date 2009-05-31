
function [ Best_PPRT, Best_Trig, Best_A, Best_B ] = ...
	pprtmin(A_Mean, A_Std, B_Mean, B_Std)

Trig = 0:100;

A = normcdf(Trig, A_Mean, A_Std);
B = normcdf(Trig, B_Mean, B_Std);

PPRT = B ./ A.^2;

[ Best_PPRT Best_Index ] = min(PPRT);
Best_Trig = Trig(Best_Index);

Best_A = A(Best_Index);
Best_B = B(Best_Index);
