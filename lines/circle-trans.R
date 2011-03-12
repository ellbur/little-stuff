
source('scale.R')
source('points.R')

circle.trans.image = function(
	Matrix
	)
{
	Points = get.points(Matrix)
	
	Trans = circle.transform(
		Points,
		list(x=CX, y=CY),
		Rad
	)
	
	CX = ncol(Matrix) / 2
	CY = nrow(Matrix) / 2
	
	Rad = sqrt(CX**2 + CY**2)
	
	list(
		Matrix = Matrix,
		CX     = CX,
		CY     = CY,
		Rad    = Rad,
		Points = Points,
		Trans  = Trans
	)
}

circle.transform = function(Points, Center, Rad)
{
	# Returns a list of (θ₁, θ₂) points
	# as list(th1=..., th2=...)
	
	DistConst = 0.2
	
	N = length(Points)
	
	ProxMatrix = matrix(0, N, N)
	ThetaPoints = matrix(list(), N, N)
	
	for (I in 1:(N-1))
	for (J in (I+1):N) {
		
		X1 = Points[[I]][['x']] - Center[['x']]
		Y1 = Points[[I]][['y']] - Center[['y']]
		
		X2 = Points[[J]][['x']] - Center[['x']]
		Y2 = Points[[J]][['y']] - Center[['y']]
		
		# x = a*t + b
		# y = c*t + d
		
		lb = X1
		ld = Y1
		
		la = X2 - X1
		lc = Y2 - Y1
		
		A = lc**2 + la**2
		B = 2*(lc*ld + la*lb)
		C = lb**2 + ld**2 - Rad**2
		
		tees = nice.quad(A, B, C)
		t1 = tees[[1]]
		t2 = tees[[2]]
		
		ix1 = la*t1 + lb;
		iy1 = lc*t1 + ld;
		
		ix2 = la*t2 + lb;
		iy2 = lc*t2 + ld;
		
		th1 = atan2(iy1, ix1)
		th2 = atan2(iy2, ix2)
		
		Th = c(th1=th1, th2=th2)
		
		ThetaPoints [[I,J]] = Th
	}
	
	ThetaPointList = find.points(ThetaPoints)
	
	for (I in 1:(N-1))
	for (J in (I+1):N) {
		Th = ThetaPoints[[I,J]]
		ProxMatrix[[I,J]] = sum(sapply(ThetaPointList, function(Th2) {
			exp(-sqrt(sum((Th-Th2)**2))/DistConst)
		}))
	}
	
	for (I in 1:(N-1))
	for (J in (I+1):N) {
		for (K in 1:N) {
			if (ProxMatrix[[I,K]] > ProxMatrix[[I,J]]) {
				ThetaPoints[[I,J]] = list()
			}
			if (ProxMatrix[[K,J]] > ProxMatrix[[I,J]]) {
				ThetaPoints[[I,J]] = list()
			}
		}
	}
	
	ThetaPointList = find.points(ThetaPoints)
	
	list(
		ThetaPoints = ThetaPointList,
		ProxMatrix  = ProxMatrix
	)
}

find.points = function(M) {
	Filter(x=c(M), f=function(X) length(X)>0)
}

rot180 = function(t) {
	t = t + pi
	if (t > pi) {
		t = t - 2*pi
	}
	t
}

rot90 = function(t) {
	t = t + pi/2
	if (t > pi) {
		t = t - 2*pi
	}
	t
}

nice.quad = function(a, b, c)
{
	# Stable quadratic formula
	# (Numerical Recipes in C)
	
	q = -0.5 * ( b + sloppy.sign(b) * sqrt(b**2 - 4*a*c) )
	
	list(q/a, c/q)
}

sloppy.sign = function(x)
{
	if (x < 0) { -1 }
	else { 1 }
}

echo = function(x)
{
	s = as.character(substitute(x));
	cat(sprintf('%s = ', s));
	print(x);
}

