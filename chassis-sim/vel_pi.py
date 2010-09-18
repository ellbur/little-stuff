#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
sys.path.append('./build/sim')

import sim
import math
from matplotlib.pyplot import *

sweep = sim.run_sim(
	duration             = 10.0,
	loop_duration        = 18.6e-3,
	sim_steps_per_loop   = 1000,
	mass                 = 20 / 2.2,
	stall_torque         = 0.7344,
	free_spin            = 100. * 2. * math.pi / 60.,
	num_motors           = 4,
	wheel_rad            = 2.0 * 2.54 / 100.,
	friction             = 5.0, # motors on order of 20N
	ticks_per_rev        = 90 * 4
)


plot(
	sweep.t, sweep.v, 'b', 
	sweep.t, sweep.vt, 'g', 
	sweep.t, sweep.user1, 'r')
show()
