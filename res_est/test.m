
Bins     = 1:100;
EvPerBin = 10;
Offset   = 0;
Lefts    = (Bins - 1) * EvPerBin;
Rights   = Lefts + EvPerBin;
Centers  = Lefts + EvPerBin/2;

Center   = 500 + 30*rand(1);
FWHM     = 110;
S        = FWHM / (2 * sqrt(2 * log(2)));
	
Jump     = 8;
	
Channels = normpdf(Centers, Center, S*S);

[ Max_Channel, Max_Bin ] = max(Channels);

Select = (Max_Bin - Jump):(Max_Bin + Jump);
IQR  = spec_iqr(Rights(Select), Channels(Select))

FWHM / IQR
