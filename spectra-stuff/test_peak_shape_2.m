
E0 = 1000;
W  = 4;
K  = 2.45;

E = 0:10:2000 + 5;

Bs     = linspace(5, 40, 20);
MSs    = zeros(size(Bs));
Widths = zeros(size(Bs));

for II=1:length(Bs)
	II
	
	B  = Bs(II);
	MS = sqrt(B*B + K*E0);
	
	Peak = condit_peak(E, E0, W, K, B);
	Width = spec_iqr(E, Peak) / 1.3490;
	
	Widths(II) = Width;
	MSs(II)    = MS;
end
