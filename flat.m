
% The following differential equattion has an equillibrium at zero
% and a solution that crosses the equillibrium.

% If d_func(0) = 0, this function is continuous, but not differentiable.
d_func = @(y) 2.*y.*(-0.5 .* log(y.^2)).^(3/2) .* sign(y);

Y1 = linspace(-0.5, 0.5, 1000);
DY1 = d_func(Y1);
DY1(Y1 == 0) = 0;

figure
plot(Y1, DY1)

X2 = linspace(-0.5, 0.5, 1000);
Y2 = exp(-2 .* X2.^(-2)) .* sign(X2);

figure
plot(X2, Y2)
