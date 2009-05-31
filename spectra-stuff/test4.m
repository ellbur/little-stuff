
edge_data
elements

Spectrum = spec2();
Spectrum.Channels   = Spectrum.Channels(1:1000);
Spectrum.Centers    = Spectrum.Centers(1:1000);
Spectrum.Resolution = 130;

%Elements = element_by_symbol({ 'Cu', 'C', 'O', 'Al', 'Si', 'S', });
Elements = element_by_symbol({ 'Cu', 'Zn', 'Al' });

[ Z EN Edges Coeffs Guess ] = try_set(Spectrum, Elements);

[ Z EN Edges Coeffs ]
