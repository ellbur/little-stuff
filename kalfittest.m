
global Point_X;
global Point_Y;
global Point_S;
global Bin_X;
global Coeff_Var;
global Coeff_Mean;
global Partial_Funcs;

Coeff_Mean = [ 0 ; 0 ; 0 ; 0 ; 0 ];
Coeff_Var  = diag([ 1e+5 1e+2 1e+1 1e+0 1e+0 ]);

Bin_X = linspace(0, 4, 20)';
Partial_Funcs = [Bin_X.^0 Bin_X.^1 Bin_X.^2 Bin_X.^3 Bin_X.^4];

Point_X = [ ];
Point_Y = [ ];
Point_S = [ ];

add_point( 1, 2.0, 1.0)
add_point( 5, 4.0, 0.4)
add_point(10, 7.0, 1.3)
add_point(17, 6.5, 0.8)
add_point(14, 5.0, 1.7)

Coeff_Mean
plot_guess()

function add_point(Bin, Y, S)
	
	global Point_X;
	global Point_Y;
	global Point_S;
	global Bin_X;
	global Coeff_Var;
	global Coeff_Mean;
	global Partial_Funcs;
	
	Point_X = [ Point_X (Bin_X(Bin)) ];
	Point_Y = [ Point_Y Y ];
	Point_S = [ Point_S S ];
	
	B = inv(Coeff_Var);
	a = Coeff_Mean;
	
	C = Partial_Funcs(Bin, :);
	D = 1/S/S;
	
	F = B + C'*D*C;
	e = F \ (B*a + C'*D*Y);
	
	Coeff_Mean = e;
	Coeff_Var  = inv(F);
	
endfunction

function plot_guess()
	
	global Point_X;
	global Point_Y;
	global Point_S;
	global Bin_X;
	global Coeff_Var;
	global Coeff_Mean;
	global Partial_Funcs;
	
	errorbar(Point_X, Point_Y, Point_S, '~');
	hold on
	plot(Bin_X, Partial_Funcs*Coeff_Mean);
	hold off
	axis([-1 5 -1 10])
	
endfunction
