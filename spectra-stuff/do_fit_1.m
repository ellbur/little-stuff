
function [Coeffs Components] = do_fit_1(Energy, Channels, Res, Edges)

FWidth = 8;

Widths = sqrt(Res*Res + 2.45*(Edges - 5895));
FChannels = top_hat(Channels', FWidth)';
Components = zeros(length(Channels), length(Edges));

for II = 1:length(Edges)
	
	Peak = peak_height(Energy, Edges(II), Widths(II), 1);
	Components(1:length(Channels), II) = Peak;
	
end

FComponents = top_hat(Components', FWidth)';

Coeffs = FComponents \ FChannels;
