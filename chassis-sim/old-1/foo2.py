# -*- coding: utf-8 -*-

from __future__ import print_function
from control import *
import numpy

param_dt   =  0.0001 # s
param_tmax = 10.0  # s

param_m    = 10.0   # kg
param_g    = 9.81  # m/s²
param_N    = param_m * param_g

param_us   = 0.50  # ul
param_uk   = 0.25  # ul
param_vmax = 0.01  # m/s

param_wheel_rad    = 0.05 # m
param_wheel_I      = 0.0002625 # kg*m²
param_stall_torque = 0.73 # N*m
param_max_speed    = 10.5 # rad/s

param_apply_t = [0, 1, 2, 3, 4, 5, 6, 7]
param_apply_s = numpy.array(
	[ 00., 00., 80., 80., 50., 50., 00., 00., ]) / 100.0

dt = lambda : param_dt

sim = Sim(dt)
t = sim.t

block  = RigidBody1D(sim, param_m, [ ], dt)

slip   = Slipper(sim, param_us, param_uk, param_vmax)
slip.N = lambda : param_N

speed = Interp(sim, param_apply_t, param_apply_s, t)

motor = Motor(sim, param_stall_torque, param_max_speed)
motor.level = speed

wheel = Wheel1D(sim, slip, motor, param_wheel_rad, param_wheel_I)
wheel.v  = block.v
wheel.dt = dt

block.forces.append(slip.F)
block.forces.append(wheel.F)

print("t,x,v,a,T,Ff,slip")

while t() < param_tmax:
	print("{0},{1},{2},{3},{4},{5},{6}".format(
		t(),
		block.x(),
		block.v(),
		block.a(),
		motor.torque(),
		slip.F(),
		wheel.vb()))
	
	sim.step()
