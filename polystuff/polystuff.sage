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

var('a b')

f(a, b) = a^2 - b^2

RHS = matrix([
	[ f.diff(a)(a, b) ],
	[ f.diff(b)(a, b) ]
])

Coeffs = aug([
	matrix([
		[ f.diff(a)(a-1, b) ],
		[ f.diff(b)(a-1, b) ]
	]),
	
	matrix([
		[ f.diff(a)(a, b-1) ],
		[ f.diff(b)(a, b-1) ]
	])
])

print('\nRHS\n')
print(RHS)

print('\nCoeffs\n')
print(Coeffs)

Ans = Coeffs.inverse() * RHS

print('\nAns\n')
print(Ans)

Loc = Ans.subs(b = a).factor()

print('\nLoc\n')
print(Loc)

print(Loc.subs(a=5))
print(Loc.subs(a=6))
