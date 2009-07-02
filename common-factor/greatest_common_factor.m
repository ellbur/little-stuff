
function F = greatest_common_factor(K, N)

Tries = fix(rande(1, N) * K);
F = gcd(Tries);
