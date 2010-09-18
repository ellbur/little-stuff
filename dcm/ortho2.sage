# -*- coding: utf-8 -*-

def t(x):
	return x.transpose()

var('a11 a12 a13 a21 a22 a23 a31 a32 a33')

# A = inv(R*R')

A = matrix(SR, [
	[ a11, a12, a13 ],
	[ a21, a22, a23 ],
	[ a31, a32, a33 ]
])

var('b11 b12 b13 b21 b22 b23 b31 b32 b33')

B = matrix(SR, [
	[ b11, b12, b13 ],
	[ b21, b22, b23 ],
	[ b31, b32, b33 ]
])

# Now fix some and subs others

var('x1 x2 x3 y1 y2 y3 y4 y5 y6')

Bp = B.subs(
	b11 = x1,
	b22 = x2,
	b33 = x3,
	
	b12 = y1,
	b13 = y2,
	b23 = y3,
	
	b21 = y4,
	b31 = y5,
	b32 = y6
)

# Bp * t(Bp) == A

BBt = Bp * t(Bp)

eqs = [ BBt[i,j] == A[i,j]
	for i in range(A.nrows())
	for j in range(A.ncols())
]

Yeqs = solve(eqs, [y1, y2, y3, y4, y5, y6])

Ysubs = { }
for eq in Yeqs:
	Ysubs[str(eq.lhs())] = eq.rhs()

Bpp = Bp.subs(**Ysubs)

Norm = sum([
	(Bpp[i,j])^2
	for i in range(Bpp.nrows())
	for j in range(Bpp.ncols())
])

Ans = solve([
	Norm.diff(x1) == 0,
	Norm.diff(x2) == 0,
	Norm.diff(x3) == 0
],
[x1, x2, x3]
)
