
from truss import *
from solver import *
from math import *

tand = lambda deg : tan(deg*pi/180.0)
sind = lambda deg : sin(deg*pi/180.0)
cosd = lambda deg : cos(deg*pi/180.0)

truss = Truss()

A = truss.joint([ cosd(180) , sind(180) ])
B = truss.joint([ cosd(180) , sind(135) ])
C = truss.joint([ cosd(180) , sind( 90) ])
D = truss.joint([ cosd(135) , sind( 90) ])
E = truss.joint([ cosd( 90) , sind( 90) ])
F = truss.joint([ cosd( 45) , sind( 90) ])
G = truss.joint([ cosd(  0) , sind( 90) ])
H = truss.joint([ cosd(  0) , sind( 45) ])
I = truss.joint([ cosd(  0) , sind(  0) ])
J = truss.joint([ cosd( 30) , sind( 30) ])
K = truss.joint([ cosd( 45) , sind( 45) ])
L = truss.joint([ cosd( 60) , sind( 60) ])
M = truss.joint([ cosd(120) , sind(120) ])
N = truss.joint([ cosd(135) , sind(135) ])
O = truss.joint([ cosd(150) , sind(150) ])

AB = truss.beam(A, B)
BC = truss.beam(B, C)
CD = truss.beam(C, D)
CN = truss.beam(C, N)
BN = truss.beam(B, N)
BO = truss.beam(B, O)
AO = truss.beam(A, O)
NO = truss.beam(N, O)
DN = truss.beam(D, N)
DM = truss.beam(D, M)
DE = truss.beam(D, E)
EM = truss.beam(E, M)
EF = truss.beam(E, F)
EL = truss.beam(E, L)
KL = truss.beam(K, L)
FK = truss.beam(F, K)
FG = truss.beam(F, G)
GH = truss.beam(G, H)
GK = truss.beam(G, K)
HK = truss.beam(H, K)
HJ = truss.beam(H, J)
JK = truss.beam(J, K)
HI = truss.beam(H, I)
IJ = truss.beam(I, J)
MN = truss.beam(M, N)
FL = truss.beam(F, L)

Ax = truss.react(A, [1, 0])
Ay = truss.react(A, [0, 1])
Ix = truss.react(I, [-1, 0])
Iy = truss.react(I, [0, 1])

truss.load(C, [0, -1])
truss.load(D, [0, -1])
truss.load(E, [0, -1])
truss.load(F, [0, -1])
truss.load(G, [0, -1])

solver = Solver()
solver.solve(truss, 2)

print "Ay = ", Ay.force
print "Ax = ", Ax.force
print "Iy = ", Iy.force
print "Ix = ", Ix.force
print
print "N = ", N.position
print "M = ", M.position
print "D = ", D.position
print
print "DM = ", DM.force
print "DN = ", DN.force
