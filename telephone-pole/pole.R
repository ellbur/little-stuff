
Vmax   =  5 * 1.467  # ft/s
Vc     = 30 * 1.467  # ft/s
Xc     = 20          # ft

DT     = 0.01

time.step = function(Old, N) {
	# Old is a list/env of state variables
	# Should return a list/env of new state variables.
	
	Yc = Old$Y / Old$X * Xc
	
	# Y*Vx + -X*Vy = Vc*Xc * (X^2 + Y^2) / (Xc^2 + Yc^2)
	# Vx^2 + Vy^2 = Vmax^2
	
	A = +Old$Y
	B = -Old$X
	C = Vc*Xc * (Old$X^2 + Old$Y^2) / (Xc^2 + Yc^2)
	D = Vmax
	
	Discr = (B^2+A^2)*D^2 - C^2
	
	if (Discr < 0) {
		Stop = 1
	}
	else if (Old$X > 0) {
		Stop = 1
	}
	else if (Old$Y > 0) {
		Stop = 1
	}
	else if (N > 1000) {
		Stop = 1
	}
	else {
		Stop = 0
		
		Vx = ( A*C + B*sqrt(Discr) ) / (B^2+A^2)
		Vy = ( B*C - A*sqrt(Discr) ) / (B^2+A^2)
		
		X = Old$X + Vx*DT
		Y = Old$Y + Vy*DT
	}
	
	rm(Old)
	
	as.list(environment())
}

sweep = function(Frame.Init, ...) {
	Frames = list()
	Frame = Frame.Init
	
	while (1) {
		Frame.Next = time.step(Frame, length(Frames))
		
		if (Frame.Next$Stop) {
			break
		}
		
		Frame = Frame.Next
		
		Frames[[length(Frames)+1]] = Frame
	}
	
	as.data.frame(t(sapply(Frames, identity)))
}

Xstart = -Vmax/Vc * Xc - 0.5
Ystart = -20

Xmin = -15
Ymin = -30

Xmax =  5
Ymax =  5

plot(c(), c(), xlim=c(Xmin, Xmax), ylim=c(Ymin, Ymax))

abline(h=0)
abline(v=0)

abline(v=-Xc*Vmax/Vc, col='grey50')

(function() {
	X = seq(-20, -Xc*Vmax/Vc, len=200)
	Y = -(X*sqrt(Vc^2*X^2-Vmax^2*Xc^2))/(Vmax*Xc)
	
	lines(X,  Y, col='yellow')
	lines(X, -Y, col='yellow')
})()


Xstep = 0.2

for (X in seq(from=Xmin, to=(-Xc*Vmax/Vc), by=Xstep)) {
	Sweep = sweep(list(X=X, Y=Ymin))
	
	if (nrow(Sweep) > 0 && ncol(Sweep) > 0) {
		with(Sweep, lines(X, Y, col='black'))
	}
}
