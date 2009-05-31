
function [ Est Var ] = kalfit(Y, SS, X, Est, Var)

B = inv(Var);
a = Est;

for Row=1:rows(Y)
	
	C = X(Row, :);
	D = 1/SS(Row);
	y = Y(Row);
	
	F = B + C'*D*C;
	e = F \ (B*a + C'*D*y);
	
	B = F;
	a = e;
end

Est = a;
Var = inv(B);
