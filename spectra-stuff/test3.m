
edge_data
elements

[ Channels, Offset, EvPerBin ] = spec1;
Channels = Channels(1:1000);

Energy = Offset + ((1:length(Channels)) - 0.5)*EvPerBin;
Energy = Energy';

Res      = 130;
Elements = { 'Cu', 'C', 'O', 'Al', 'Si', 'S', };
FWidth   = 8;

Spectrum.Channels   = Channels;
Spectrum.Centers    = Energy;
Spectrum.Resolution = Res;

Z = element_by_symbol(Elements);

[Edges ZList] = edges_by_element(Z);
Num_Edges_1 = length(Edges);

Full_Edges = Edges;
Full_ZList = ZList;
Edge_Indices = 1:Num_Edges_1;

[Coeffs Components] = do_fit_1(Spectrum, Edges);

while any(Coeffs <= 0)
	Edges = Edges(Coeffs > 0);
	ZList = ZList(Coeffs > 0);
	Edge_Indices = Edge_Indices(Coeffs > 0);
	
	[Coeffs Components] = do_fit_1(Spectrum, Edges);
end

Num_Edges_2 = length(Edges);
Guess = Components * Coeffs;

Elements2 = symbol_by_element(ZList);

Full_Coeffs = zeros(Num_Edges_1, 1);
Full_Coeffs(Edge_Indices) = Coeffs;

[Full_ZList Full_Edges Full_Coeffs]
