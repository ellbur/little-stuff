
from truss import *
from solver import *
from math import *

tand = lambda deg : tan(deg*pi/180.0)
sind = lambda deg : sin(deg*pi/180.0)
cosd = lambda deg : cos(deg*pi/180.0)

truss = Truss()

A = truss.joint([ 0 , 0 ])
B = truss.joint([ 0.5 , 3 ])
C = truss.joint([ 2 , 4.5 ])
D = truss.joint([ 3.5 , 3 ])
E = truss.joint([ 4 , 0 ])
F = truss.joint([ 2 , 3.0/3.5*2 ])

AB = truss.beam(A, B)
BC = truss.beam(B, C)
CD = truss.beam(C, D)
DE = truss.beam(D, E)
EF = truss.beam(E, F)
DF = truss.beam(D, F)
BF = truss.beam(B, F)
BD = truss.beam(B, D)
AF = truss.beam(A, F)

Ax = truss.react(A, [1, 0])
Ay = truss.react(A, [0, 1])
Ey = truss.react(E, [0, 1])

truss.load(C, [0, -8])

solver = Solver()
solver.solve(truss, 2)

print "Ax = ", Ax.force
print "Ay = ", Ay.force
print "Ey = ", Ey.force
print
print "AF = ", AF.force
print "EF = ", EF.force
print "BF = ", BF.force
