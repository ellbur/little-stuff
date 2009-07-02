
So_Far = [ 869 1106 237 632 ];

K = mean(So_Far)
N = 4

Num_Trials = 100000;
Greatest_Factors = zeros(Num_Trials, 1);

for II=1:Num_Trials
	
	Greatest_Factor = greatest_common_factor(K, N);
	Greatest_Factors(II) = Greatest_Factor;
	
end

Dist = accumarray(Greatest_Factors, ones(size(Greatest_Factors)));
