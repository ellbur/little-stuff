
function Asym = spec_asym(Rights, Channels)

Quantiles = cumsum(Channels) / sum(Channels);

Q1 = interp1(Quantiles, Rights, 0.25);
Q2 = interp1(Quantiles, Rights, 0.50);
Q3 = interp1(Quantiles, Rights, 0.75);

IQR = Q3 - Q1;

Asym = (Q3 + Q1 - 2*Q2) / IQR;
