#!/usr/bin/env sage
# -*- coding: utf-8 -*-

import sys
sys.path.append('/usr/lib/pymodules/python2.6/')

from sage.all import *
from first import *
from sorti import *
from random import *

DenSource = first(Primes(), 20)
Rats = [ ]

for Den in DenSource:
	for Num in range(1, Den):
		
		Rats.append( Num/Den )

LA = Rats[:-1]
LB = Rats[1:]

A = [ [0, 0], [1, 1] ]       + [ [a, None]  for a in LA ]
B = [ [0, True], [1, True] ] + [ [b, False] for b in LB ]

AI, AIR = sorti(A, lambda (a1,b1), (a2,b2): int(sign(a1-a2)) )

def box(i, step, cap):
	j = AIR[i] + step
	
	while j >= 0:
		i2 = AI[j]
		[a, b] = A[i2]
		
		if b != None:
			return b
		
		j += step
	
	return cap

def dn_box(i):
	return box(i, -1, 0)

def up_box(i):
	return box(i, +1, 1)

for i in range(2, len(A)):
	p = A[i]
	[a, _ig] = p
	
	b_dn = dn_box(i)
	b_up = up_box(i)
	
	found = False
	
	for pb in B:
		[b, taken] = pb
		
		if (not taken) and (b_dn < b) and (b < b_up):
			found = True
			break
	
	if found:
		pb[1] = True
		p[1] = b

A = [ [a,b] for [a,b] in A if b != None ]
A.sort(lambda (a1,b1), (a2,b2): int(sign(a1-a2)))

X = [ float(a) for [a,b] in A ]
Y = [ float(b) for [a,b] in A ]
