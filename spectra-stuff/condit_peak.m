
function Distr = condit_peak(Values, E0, W, K, B)

E1_Min = E0 - W*40;
E1_Max = E0 + W*40;
E1_Values = linspace(E1_Min, E1_Max, 1000);

E1 = cauchy_pdf(E1_Values, E0, W);

E2_Func = @(E) normpdf(Values, E, sqrt(K*E + B*B));

Distr = condit_accum(E1_Values, E1, E2_Func);
