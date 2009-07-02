
W = 1;
K = 2.45;
B = 40;

E = -100:10:10000 + 5;

Peak_Centers = linspace(200, 2000, 10);
Peak_Widths  = zeros(size(Peak_Centers));

for II=1:length(Peak_Centers);
	II
	
	Center = Peak_Centers(II);
	Spec = condit_peak(E, Center, W, K, B);
	
	Width = spec_iqr(E, Spec) / 1.3490;
	Peak_Widths(II) = Width;
end

polyfit(Peak_Centers, Peak_Widths.^2, 1)
