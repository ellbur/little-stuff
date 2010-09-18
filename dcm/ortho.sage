# -*- coding: utf-8 -*-

from sage.all import *

var('a11 a12 a13 ' +
    'a21 a22 a23 ' +
    'a31 a32 a33')

c1 = vector([a11, a21, a31])
c2 = vector([a12, a22, a32])
c3 = vector([a13, a23, a33])

vars = (a11, a12, a13, a21, a22, a23, a31, a32, a33)

x12 = c1.cross_product(c2)
x23 = c2.cross_product(c3)
x31 = c3.cross_product(c1)

g1 = (x12[0] - c3[0]).function(*vars)
g2 = (x12[1] - c3[1]).function(*vars)
g3 = (c1.dot_product(c1) - 1).function(*vars)

g4 = (x23[0] - c1[0]).function(*vars)
g5 = (x23[1] - c1[1]).function(*vars)
g6 = (c2.dot_product(c2) - 1).function(*vars)

var('b11 b12 b13 ' +
    'b21 b22 b23 ' +
    'b31 b32 b33')

var('x11 x12 x13 ' +
    'x21 x22 x23 ' +
    'x31 x32 x33')

B = matrix([
	[ b11, b12, b13 ],
	[ b21, b22, b23 ],
	[ b31, b32, b33 ]
])

X = matrix([
	[ x11, x12, x13 ],
	[ x21, x22, x23 ],
	[ x31, x32, x33 ]
])

BX = B + X

a_subs = { }
for i in range(3):
	for j in range(3):
		a_subs['a{0}{1}'.format(i+1, j+1)] = BX[i,j]

xvars = ( x11, x12, x13, x21, x22, x23, x31, x32, x33 )

g1 = g1(**a_subs)
g2 = g2(**a_subs)
g3 = g3(**a_subs)
g4 = g4(**a_subs)
g5 = g5(**a_subs)
g6 = g6(**a_subs)

xv = vector(xvars)
f = xv.dot_product(xv)

var('l1 l2 l3 l4 l5 l6')
lvars = (l1, l2, l3, l4, l5, l6)

eqs = [ ]

eqs.append(g1 == 0)
eqs.append(g2 == 0)
eqs.append(g3 == 0)
eqs.append(g4 == 0)
eqs.append(g5 == 0)
eqs.append(g6 == 0)

for xvar in xvars:
	eqs.append(f.diff(xvar) ==
		l1*g1.diff(xvar) +
		l2*g2.diff(xvar) +
		l3*g3.diff(xvar) +
		l4*g4.diff(xvar) +
		l5*g5.diff(xvar) +
		l6*g6.diff(xvar)
	)

allvars = xvars + lvars
