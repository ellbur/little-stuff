
source('window.R')

Σ = sum

project = function(u, v) {
	v = v / sqrt(Σ(v^2))
	Σ(u*v)
}

pol = function(θ) {
	c(cos(θ), sin(θ))
}

pendulum.step.trans = function(θ, gx, gy) {
	
	φ = pi/2 - θ
	mot = pol(φ)
	
	a = project(c(gx, gy), mot)
	
	list(
		a = a
	)
}

pendulum.step = function(L, θ, ω, a0, g, kf, dt) {
	
	a0x = a0[[1]]
	a0y = a0[[2]]
	
	gx = -a0x
	gy = -a0y - g
	
	step.trans = pendulum.step.trans(θ, gx, gy)
	
	α = step.trans[['a']] / L
	ωp = ω*exp(-kf*dt) + α*dt
	θp = θ + ω*dt
	
	list(
		θ = θp,
		ω = ωp
	)
}
	
pendulum.sim.1 = function() {
	
	dt = 0.001
	plot.freq = 0.1
	
	group.n = round(plot.freq / dt)
	plot.freq = group.n * dt
	
	L = 1.0
	g = 9.8
	
	θ = -pi/2 + pi/2*0.30
	ω = 0
	
	kf = 1/10
	
	t = 0
	
	Frame = make.window('Time', 20)
	
	while (1) {
		
		Frame = add.row.window(Frame, data.frame(
			Time  = t,
			Angle = (θ + pi/2) * 180 / pi
		))
		
		layout(matrix(1:2, nrow=1))
		
		plot(1, xlim=c(-2, 2), ylim=c(-2, 2), type='n', axes=F, ann=F)
		arrows(0, 0, L*cos(θ), L*sin(θ))
		
		plot(1,
			xlim = c(left.window(Frame), right.window(Frame)),
			ylim = c(-90, 90),
			axes = F,
			ann  = F,
			type = 'n'
		)
		lines(Frame$Time, Frame$Angle)
		abline(h=0)
		
		Sys.sleep(plot.freq)
		
		II = 0
		while (II < group.n) {
			Res = pendulum.step(L, θ, ω, c(0, 0), g, kf, dt)
			
			θ = Res[['θ']]
			ω = Res[['ω']]
			
			t = t + dt
			
			II = II + 1
		}
	}
}
