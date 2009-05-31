
function N = num_series(Z)

N = Z;
N(N <= 3)  = 1;
N(N >= 57) = 3;
N(N >= 21) = 2;
N(N >=  4) = 1;
