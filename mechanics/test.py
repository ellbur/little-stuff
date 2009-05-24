
from truss import *
from solver import *

truss = Truss()

A = truss.joint([0, 0], 'A')
B = truss.joint([5, 0], 'B')
C = truss.joint([2, 4], 'C')

AB = truss.beam(A, B)
AC = truss.beam(A, C)
BC = truss.beam(B, C)

Ax = truss.react(A, [1,0])
Ay = truss.react(A, [0,1])
By = truss.react(B, [0,1])

L = truss.load(C, [100, -50])

solver = Solver()
solver.solve(truss, 2)
