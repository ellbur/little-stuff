
from __future__ import print_function
import numpy as np

T_seg = 1.0

t = np.array([0.0])
u = np.array([0.0])

freqs = [1.0, 2.0, 3.0, 4.0]

for k in range(len(freqs)):
    tp = np.linspace(max(t), max(t)+T_seg, 50)
    up = np.cos(2*np.pi*freqs[k]*tp)
    t = np.concatenate((t,tp))
    u = np.concatenate((u,up))

out = open('./source.sp', 'w')
def p(l):
    print(l, file=out)

p('')
p('.subckt src p n')
p('V p n PWL(')
for i in range(len(t)):
    p('+ {0} {1}'.format(t[i], u[i]))
p('+)')
p('.ends')

out.close()

