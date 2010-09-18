
circle = function(CX, CY, Rad, ...) {
	Theta = seq(0, 2*pi, len=100)
	X = CX + Rad*cos(Theta)
	Y = CY + Rad*sin(Theta)
	
	lines(X, Y, ...)
}

Vmax   =  5 * 1.467  # ft/s
Vc     = 30 * 1.467  # ft/s
Xc     = 20          # ft

X      = -Vmax/Vc * Xc - 1
Y      = -5

Yc = Y / X * Xc

A = +Y
B = -X
C = Vc*Xc * (X^2 + Y^2) / (Xc^2 + Yc^2)
D = Vmax

Vx1 = ( A*C - B*sqrt((B^2+A^2)*D^2 - C^2) ) / (B^2+A^2)
Vy1 = ( B*C + A*sqrt((B^2+A^2)*D^2 - C^2) ) / (B^2+A^2)

Vx2 = ( A*C + B*sqrt((B^2+A^2)*D^2 - C^2) ) / (B^2+A^2)
Vy2 = ( B*C - A*sqrt((B^2+A^2)*D^2 - C^2) ) / (B^2+A^2)

plot(c(), c(), xlim=c(-30, 30), ylim=c(-30, 30))

abline(h=0)
abline(v=0)

points(X, Y,   pch='p')
points(Xc, Yc, pch='c')

abline(0, Y/X, col='grey50')
abline(v=-Xc*Vmax/Vc, col='grey60')

circle(X, Y, Vmax)
arrows(X, Y, X+Vx1, Y+Vy1, col='red')
arrows(X, Y, X+Vx2, Y+Vy2, col='green')
