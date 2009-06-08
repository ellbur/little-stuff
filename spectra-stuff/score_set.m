
function Scores = score_set(Spectrum, Sample)

Fit_Group = [ 1 1 2 2 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 ];

Scores = zeros(size(Sample));

Fit = try_set(Spectrum, Sample);
Fit_Groups = Fit_Group(Fit.Edge_Numbers)';

for II = 1:length(Sample)
	
	Z = Sample(II);
	
	Select = (Fit.ZList == Z);
	if length(Select) == 0
		Scores(II) = 0;
		continue
	end
	
	Sums = accumarray(Fit_Groups(Select), Fit.Coeffs(Select));
	Scores(II) = min(Sums);
end
