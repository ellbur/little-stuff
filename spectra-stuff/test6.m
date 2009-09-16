
edge_data
elements

global EdgeData;

Spectrum = random_spectrum('/home/owen/stuff/pulsetor/new-spectra/20090623 Nickel Brit');
Spectrum.Resolution = est_resolution(Spectrum);

Test_Elements = 3:80;

Sums   = zeros(rows(EdgeData), 1);
Counts = zeros(rows(EdgeData), 1);

for Z=Test_Elements
	
	Score = score_set(Spectrum, Z);
	
	Sums(Z)   = Sums(Z) + Score;
	Counts(Z) = Counts(Z) + 1;
	
	fprintf('Tested %s for score %e\n', symbol_by_element(Z), Score);
end

Counts(Counts == 0) = 1;
Scores = Sums ./ Counts;

[ Ignored Rank ] = sort(-Scores);

Best_Elements = Rank(1:20);

% This does not really improve much
%
%  for II = 1:length(Best_Elements)
%  for JJ = (II+1):length(Best_Elements)
%  	
%  	Z1 = Best_Elements(II);
%  	Z2 = Best_Elements(JJ);
%  	
%  	Score = score_set(Spectrum, [Z1 Z2]);
%  	
%  	Sums(Z1) = Sums(Z1) + Score(1);
%  	Sums(Z2) = Sums(Z2) + Score(2);
%  	
%  	Counts(Z1) = Counts(Z1) + 1;
%  	Counts(Z2) = Counts(Z2) + 1;
%  	
%  	fprintf('Tested %s,%s for score %e,%e\n', ...
%  		symbol_by_element(Z1), ...
%  		symbol_by_element(Z2), ...
%  		Score(1),              ...
%  		Score(2) );
%  end
%  end
%  
%  Scores = Sums ./ Counts;
%  [ Ignored Rank ] = sort(-Scores);
%  
%  Bestest_Elements = Rank(1:10);

Spectrum.File
symbol_by_element(Best_Elements)


