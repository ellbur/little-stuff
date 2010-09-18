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

def stack(seq):
	if len(seq) == 0:
		raise Exception
	
	it = iter(seq)
	A = next(it)
	
	for B in it:
		A = A.stack(B)
	
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
	(a,   b,   c-1 ),
	(a-1, b-1, c-1 ),
	(a,   b,   c   )
]

RHS = g()

Coeffs = aug([
	g(*Back) for Back in Backs
])

Partics = [
	{'a':3, 'b': 4, 'c': 5},
	{'a':5, 'b':12, 'c':13},
	{'a':5, 'b':12, 'c':13}
]

RHS_P    = stack([ RHS.subs(**P)    for P in Partics ])
Coeffs_P = stack([ Coeffs.subs(**P) for P in Partics ])

print('\nRHS\n')
print(RHS)

print('\nCoeffs\n')
print(Coeffs)

print('\nRHS_P\n')
print(RHS_P)

print('\nCoeffs_P\n')
print(Coeffs_P)

Sol = Coeffs_P \ RHS_P

print('\nSol\n')
print(Sol)

Kernel = Coeffs_P.transpose().kernel()

print('\nKernel\n')
print(Kernel)

Test = sum([
	Sol[i] * f(*Backs[i]) for i in range(Sol.ncols())
])

print('\nTest\n')
print(Test)
