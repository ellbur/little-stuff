
from truss import *
from solver import *
from math import *

tand = lambda deg : tan(deg*pi/180.0)

truss = Truss()

B = truss.joint([  0 ,  6 ])
C = truss.joint([  8 ,  6 +  8*tand(30) ])
D = truss.joint([ 16 ,  6 + 16*tand(30) ])

E = truss.joint([ 24 ,  6 + 24*tand(30) ])

F = truss.joint([ 32 ,  6 + 16*tand(30) ])
G = truss.joint([ 40 ,  6 +  8*tand(30)  ])
H = truss.joint([ 48 ,  6 ])

I = truss.joint([ 48 ,  0 ])
J = truss.joint([ 40 ,  8*tand(25) ])
K = truss.joint([ 32 , 16*tand(25) ])

L = truss.joint([ 24 , 24*tand(25) ])

M = truss.joint([ 16 , 16*tand(25) ])
N = truss.joint([  8 ,  8*tand(25) ])
A = truss.joint([  0 ,  0 ])

AB = truss.beam(A, B)
truss.beam(B, C)
truss.beam(C, D)
DE = truss.beam(D, E)
truss.beam(E, F)
truss.beam(F, G)
truss.beam(G, H)
truss.beam(H, I)
truss.beam(I, J)
truss.beam(J, K)
truss.beam(K, L)
LM = truss.beam(L, M)
truss.beam(M, N)
AN = truss.beam(N, A)

truss.beam(N, B)
truss.beam(M, C)
DL = truss.beam(L, D)
EL = truss.beam(L, E)
truss.beam(L, F)
truss.beam(K, G)
truss.beam(J, H)

truss.beam(N, C)
truss.beam(M, D)
truss.beam(K, F)
truss.beam(J, G)

truss.load(B, [0, -0.5])
truss.load(C, [0, -1])
truss.load(D, [0, -1])
truss.load(E, [0, -1])
truss.load(F, [0, -1])
truss.load(G, [0, -1])
truss.load(H, [0, -0.5])

Ax = truss.react(A, [1, 0])
Ay = truss.react(A, [0, 1])
Iy = truss.react(I, [0, 1])

solver = Solver()
solver.solve(truss, 2)

print "A = ", A.position
print "L = ", L.position
print "G = ", G.position

print "DE = ", DE.force
print "DL = ", DL.force
print "LM = ", LM.force
print "EL = ", EL.force

print "Ax = ", Ax.force
print "Ay = ", Ay.force
print "Iy = ", Iy.force

print "AB = ", AB.force
print "AN = ", AN.force
