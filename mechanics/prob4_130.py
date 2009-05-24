
from truss import *
from solver import *
from math import *

tand = lambda deg : tan(deg*pi/180.0)
sind = lambda deg : sin(deg*pi/180.0)
cosd = lambda deg : cos(deg*pi/180.0)

truss = Truss()

A = truss.joint([  -3    ,  0   ])
B = truss.joint([  -3    ,  1   ])
C = truss.joint([  -1.5  ,  1.5 ])
D = truss.joint([   0    ,  2   ])
E = truss.joint([   1.5  ,  1.5 ])
F = truss.joint([   3    ,  1   ])
G = truss.joint([   3    ,  0   ])
H = truss.joint([   0    ,  0   ])

AB = truss.beam(A, B)
BC = truss.beam(B, C)
CD = truss.beam(C, D)
DE = truss.beam(D, E)
EF = truss.beam(E, F)
FG = truss.beam(F, G)
GH = truss.beam(G, H)
AH = truss.beam(A, H)
CH = truss.beam(C, H)
EH = truss.beam(E, H)
EG = truss.beam(E, G)
AC = truss.beam(A, C)
DH = truss.beam(D, H)

Ax = truss.react(A, [1, 0])
Ay = truss.react(A, [0, 1])
Gy = truss.react(G, [0, 1])

truss.load(B, [0, -1.5])
truss.load(C, [0, -3])
truss.load(D, [0, -3])
truss.load(E, [0, -3])
truss.load(F, [0, -1.5])

solver = Solver()
solver.solve(truss, 2)

print "Ax = ", Ax.force
print "Ay = ", Ay.force
print "Gy = ", Gy.force
print
print "CD = ", CD.force
print "CH = ", CH.force
print "AH = ", AH.force
