#!/usr/bin/env sage
# -*- coding: utf-8 -*-

def aug(seq):
	if len(seq) == 0:
		raise Exception
	
	it = iter(seq)
	A = next(it)
	
	for B in it:
		A = A.augment(B)
	
	return A

def grad(u):
	Vars = u.args()
	
	return matrix([
		[u.diff(v)] for v in Vars
	])

var('a b c d e f')

f(a, b, c) = a^2 + b^2 - c^2
g = grad(f)

print('\nf\n')
print(f)

print('\ng\n')
print(g)

Backs = [
	(a-1, b,   c   ),
	(a,   b-1, c   ),
	(a,   b,   c-1 )
]

RHS = g()

Coeffs = aug([
	g(*Back) for Back in Backs
])

print('\nRHS\n')
print(RHS)

print('\nCoeffs\n')
print(Coeffs)

Sol = (Coeffs.inverse() * RHS).factor()

print('\nSol\n')
print(Sol)

Partics = [
	{'a':3, 'b': 4, 'c': 5},
	{'a':9, 'b':40, 'c':41},
	{'a':5, 'b':12, 'c':13}
]

print('\nf(Partic)\n')
print([ f(**P) for P in Partics ])

print('\nSol(Partic)\n')
for S in [ Sol(**P) for P in Partics ]:
	print('\n')
	print(S)
