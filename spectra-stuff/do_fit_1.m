
function Reg = do_fit_1(Spectrum, Edges, Filter=@fitting_filter)

if length(Edges) == 0
	Reg.Coeffs = [];
	Reg.Components = [];
	return
end

Channels = Spectrum.Channels;
Res      = Spectrum.Resolution;
Energy   = Spectrum.Centers;

Widths = sqrt(Res*Res + 2.45*(Edges - 5895));
FChannels = Filter(Channels')';
Components = zeros(length(Channels), length(Edges));

for II = 1:length(Edges)
	
	Peak = peak_height(Energy, Edges(II), Widths(II), 1);
	FPeak = fitting_filter(Peak')';
	
	Components(1:length(Channels), II) = Peak;
	FComponents(1:length(FPeak), II) = FPeak;
end

Reg.Coeffs = FComponents \ FChannels;
Reg.Components = Components;
