
source('meshgrid.R')

X = seq(0, 1, len=20)
Y = seq(0, 1, len=20)

Grad.X.Func = function(X, Y) {
	X - Y
}

Grad.Y.Func = function(X, Y) {
	(0.5 - Y)**2 - (0.5 - X)**2 + 0.5*X
}

l(XX, YY) %=% meshgrid(X, Y)

Grad.X = Grad.X.Func(XX, YY)
Grad.Y = Grad.Y.Func(XX, YY)

