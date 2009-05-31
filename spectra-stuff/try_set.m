
function Fit = try_set(Spectrum, Elements)

FWidth = 8;

[Edges Z Edge_Numbers] = edges_by_element(Elements);

Select = (Edges >= min(Spectrum.Centers)) & (Edges <= max(Spectrum.Centers));
Edges        = Edges(Select);
Z            = Z(Select);
Edge_Numbers = Edge_Numbers(Select);

Num_Edges = length(Edges);
Full_Edges = Edges;
Edge_Indices = 1:Num_Edges;

Reg = do_fit_1(Spectrum, Edges);

while any(Reg.Coeffs <= 0)
	[ Smallest Get_Out ] = min(Reg.Coeffs);
	Select = (1:length(Edges)) ~= Get_Out;
	
	Edges = Edges(Select);
	Edge_Indices = Edge_Indices(Select);
	
	Reg = do_fit_1(Spectrum, Edges);
end

Full_Coeffs = zeros(Num_Edges, 1);
Full_Coeffs(Edge_Indices) = Reg.Coeffs;

Fit.Edges        = Full_Edges;
Fit.Coeffs       = Full_Coeffs;
Fit.ZList        = Z;
Fit.Series       = series(Edge_Numbers)';
Fit.Edge_Numbers = Edge_Numbers;
Fit.Guess        = Reg.Components * Reg.Coeffs;
Fit.Regression   = Reg;
