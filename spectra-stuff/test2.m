
X = 1:100;

M1 = 45;
M2 = 60;

A1 = 1500;
A2 = 1000;

S1 = 10;
S2 = 12;

FSize = 8;

% For a start, let's do no background
BG = 30 + cumsum(rand(size(X)) - rand(size(X)));

Peak1 = A1 * normal_pdf(X, M1, S1*S1);
Peak2 = A2 * normal_pdf(X, M2, S2*S2);

Y = BG + Peak1 + Peak2;

FY = top_hat(Y, FSize);

% OK, now we need the templates to fit against

TL1 = normal_pdf(X, M1, S1*S1);
TL2 = normal_pdf(X, M2, S2*S2);

FTL1 = top_hat(TL1, FSize);
FTL2 = top_hat(TL2, FSize);

% The equation is Y = c1*TL1 + c2*TL2

Sol1 = [TL1' TL2']   \ (Y');
Sol2 = [FTL1' FTL2'] \ (FY');

Sol1
Sol2
