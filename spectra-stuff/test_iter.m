
edge_data
elements

global EdgeData;

Spectrum = random_spectrum();
Spectrum.Resolution = est_resolution(Spectrum);

Spectrum.File

Elem_Start =  3;
Elem_Stop  = 80;

Elements = (Elem_Start:Elem_Stop)';

Group_Size = 2;
Num_Iters  = length(Elements);

Count_Table  = zeros(rows(EdgeData), 1);

Result_Set = cell(rows(EdgeData), 1);

for Iter=1:Num_Iters
	
	Sample  = Elements(Iter);
	while length(Sample) < Group_Size
		Sample = [ Sample Elements(1+floor(rand(1)*length(Elements))) ];
		Sample = unique(Sample);
	end
	
	Fit = try_set(Spectrum, Sample);
	
	Count_Table(Sample) = Count_Table(Sample) + 1;
	
	for II=1:length(Sample)
		
		Z = Sample(II);
		Result = Result_Set{Z};
		C = Count_Table(Z);
		
		Result(C).Sum = sum(Fit.Coeffs(Fit.ZList == Z));
		Result(C).S1  = sum(Fit.Coeffs(Fit.ZList == Z & Fit.Series == 1));
		Result(C).S2  = sum(Fit.Coeffs(Fit.ZList == Z & Fit.Series == 2));
		Result(C).S3  = sum(Fit.Coeffs(Fit.ZList == Z & Fit.Series == 3));
		
		Result(C).S   = zeros(1, num_series(Z));
		
		if num_series(Z) >= 1
			Result(C).S(1) = Result(C).S1;
		end
		
		if num_series(Z) >= 2
			Result(C).S(2) = Result(C).S2;
		end
		
		if num_series(Z) >= 3
			Result(C).S(3) = Result(C).S3;
		end
		
		Result(C).SMin    = min(Result(C).S);
		
		Result_Set{Z} = Result;
	end
end

SMin = zeros(rows(EdgeData), 1);
for II = 1:length(SMin)
	R = Result_Set{II};
	
	if ~isstruct(R)
		continue;
	end
	
	SMin(II) = median([R.SMin]);
end

[ Rank Best ] = sort(-SMin);
Rank = -Rank;

symbol_by_element(Best(1:7))
