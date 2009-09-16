
Middle = 1000;
Sep    =  400;
Res    =  130;

Ev_Per_Bin = 10;
Bins       = (0:4095)';
Lefts      = Bins * Ev_Per_Bin;
Rights     = (Bins+1) * Ev_Per_Bin;
Centers    = (Bins+0.5) * Ev_Per_Bin;

Energies = [
	(Middle - Sep/2),
	(Middle + Sep/2) ]
Heights = [
	1000,
	1000 ]
Widths = sqrt(Res*Res + 2.45*(Energies - 5895))

Channels = zeros(size(Centers));
for II = 1:length(Energies)	
	Channels = Channels + peak_height(Centers,
		Energies(II), Widths(II), Heights(II));
end

Spectrum.Channels    = Channels;
Spectrum.Centers     = Centers;
Spectrum.Resolution  = Res;

Reg = do_fit_1(Spectrum, Middle, @top_hat);
Fit = Reg.Coeffs * Reg.Components;

Look = 60:140;

plot(Centers(Look), Channels(Look), Centers(Look), Fit(Look))
print('./plots/top-hat-problem-1.png', '-dpng');

FChannels = top_hat(Channels(Look)')';
FFit      = top_hat(Fit(Look)')';

FBins = (1:rows(FChannels))';

plot(FBins, FChannels, FBins, FFit);
print('./plots/top-hat-problem-2.png', '-dpng');

mean(Fit)
mean(Channels)
