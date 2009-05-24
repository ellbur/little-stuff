
from truss import *
from solver import *
from math import *

tand = lambda deg : tan(deg*pi/180.0)
sind = lambda deg : sin(deg*pi/180.0)
cosd = lambda deg : cos(deg*pi/180.0)

truss = Truss()

A = truss.joint([  0   ,  0 ])
B = truss.joint([  7.5 ,  5 ])
C = truss.joint([ 15   , 10 ])
D = truss.joint([ 22.5 ,  5 ])
E = truss.joint([ 30   ,  0 ])
F = truss.joint([ 15   ,  0 ])

AB = truss.beam(A, B)
BC = truss.beam(B, C)
CD = truss.beam(C, D)
CF = truss.beam(C, F)
BF = truss.beam(B, F)
DF = truss.beam(D, F)
DE = truss.beam(D, E)
EF = truss.beam(E, F)
AF = truss.beam(A, F)

Ax = truss.react(A, [1, 0])
Ay = truss.react(A, [0, 1])
Ey = truss.react(E, [0, 1])

truss.load(B, [0, -5])
truss.load(C, [0, -5])
truss.load(D, [0, -5])

solver = Solver()
solver.solve(truss, 2)

print "Ax = ", Ax.force
print "Ay = ", Ay.force
print "Ey = ", Ey.force
print
print "AB = ", AB.force
print "BC = ", BC.force
print "CD = ", CD.force
print "CF = ", CF.force
print "BF = ", BF.force
print "DF = ", DF.force
print "DE = ", DE.force
print "EF = ", EF.force
print "AF = ", AF.force
