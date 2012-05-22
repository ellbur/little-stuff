
import vcd
from properties import *

d = vcd.parse_vcd('dump.vcd')
print('reset {0} times'.format(
    asserted_times(d.reset())
))

print('{0} edges'.format(
    asserted_times(d.uut_g.edge())
))

print('{0} pileups'.format(
    asserted_times(d.uut_g.pileup())
))

