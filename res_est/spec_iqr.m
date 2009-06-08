
function IQR = spec_iqr(Rights, Channels)

Quantiles = cumsum(Channels) / sum(Channels);

Q1 = interp1(Quantiles, Rights, 0.25);
Q3 = interp1(Quantiles, Rights, 0.75);

IQR = Q3 - Q1;
