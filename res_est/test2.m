
Bins     = 1:100;
EvPerBin = 10;
Offset   = 0;
Lefts    = (Bins - 1) * EvPerBin;
Centers  = Lefts + EvPerBin/2;

Center   = 500 + 30*rand(1);
FWHM     = 113;
S        = FWHM / (2 * sqrt(2 * log(2)));

Channels = normal_pdf(Centers, Center, S*S);

[ Max_Channel, Max_Bin ] = max(Channels);
