
function Resolution = est_resolution(Spectrum)

[ Max_Height, Max_Bin ] = max(Spectrum.Channels);

Half_Height = Max_Height / 2;

Left_Half_Bin  = 0;
Right_Half_Bin = 0;

JJ = Max_Bin;
while JJ >= 1
	if Spectrum.Channels(JJ) <= Half_Height
		Left_Half_Bin =  JJ + (Half_Height - Spectrum.Channels(JJ)) ...
			/ (Spectrum.Channels(JJ+1) - Spectrum.Channels(JJ));
		
		break;
	end
	
	JJ = JJ - 1;
end

JJ = Max_Bin;
while JJ <= length(Spectrum.Channels)
	if Spectrum.Channels(JJ) <= Half_Height
		Right_Half_Bin =  JJ-1 + (Half_Height - Spectrum.Channels(JJ-1)) ...
			/ (Spectrum.Channels(JJ) - Spectrum.Channels(JJ-1));
		
		break;
	end
	
	JJ = JJ + 1;
end

FWHM = (Right_Half_Bin - Left_Half_Bin) * Spectrum.EvPerBin;
Center = Spectrum.Centers(Max_Bin);

Resolution = sqrt(FWHM*FWHM - 2.45*(Center - 5895));
