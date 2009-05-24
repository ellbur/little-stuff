
edge_data
elements

[ Channels, Offset, EvPerBin ] = spec1;
Channels = Channels(1:1000);

Energy = Offset + ((1:length(Channels)) - 0.5)*EvPerBin;
Energy = Energy';

Res      = 130;
Elements = { 'Cu', 'C', 'O', 'Al', 'Si', 'S', };
FWidth   = 8;

Edges = get_edges_by_elements(element_by_symbol(Elements));
Edges = sort(Edges);
Num_Edges_1 = length(Edges);

[Coeffs Components] = do_fit_1(Energy, Channels, Res, Edges);

while any(Coeffs <= 0)
	Edges = Edges(Coeffs > 0);
	[Coeffs Components] = do_fit_1(Energy, Channels, Res, Edges);
end

Num_Edges_2 = length(Edges);
Guess = Components * Coeffs;
