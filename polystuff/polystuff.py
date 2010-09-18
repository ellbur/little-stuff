# This file was *autogenerated* from the file polystuff.sage.
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_6 = Integer(6); _sage_const_5 = Integer(5)#!/usr/bin/env sage -python
# -*- coding: utf-8 -*-

def aug(seq):
	if len(seq) == _sage_const_0 :
		raise Exception
	
	it = iter(seq)
	A = next(it)
	
	for B in it:
		A = A.augment(B)
	
	return A

var('a b')

__tmp__=var("a,b"); f = symbolic_expression(a**_sage_const_2  - b**_sage_const_2 ).function(a,b)

RHS = matrix([
	[ f.diff(a)(a, b) ],
	[ f.diff(b)(a, b) ]
])

Coeffs = aug([
	matrix([
		[ f.diff(a)(a-_sage_const_1 , b) ],
		[ f.diff(b)(a-_sage_const_1 , b) ]
	]),
	
	matrix([
		[ f.diff(a)(a, b-_sage_const_1 ) ],
		[ f.diff(b)(a, b-_sage_const_1 ) ]
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

print(Loc.subs(a=_sage_const_5 ))
print(Loc.subs(a=_sage_const_6 ))