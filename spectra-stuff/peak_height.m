
function Counts = peak_height(Energies, Center, Width, Amp)

S = Width / (2 * sqrt(2*log(2)));

Counts = Amp * exp(
	- ((Energies - Center) ./ S).^2 / 2);
