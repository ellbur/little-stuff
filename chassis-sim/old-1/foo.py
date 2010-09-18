# -*- coding: utf-8 -*-

from __future__ import print_function
from math import *

class Slip:
	
	def __init__(self, us, uk, vmax):
		self.us   = us
		self.uk   = uk
		self.vmax = vmax
	
	def get_force(self, N, v):
		if N <= 0: return 0
		
		if v < -self.vmax: return +self.uk * N
		if v > +self.vmax: return -self.uk * N
		
		return -self.us*N / self.vmax * v
	
	def get_mode(self, N, v):
		if v < -self.vmax: return -1
		if v > +self.vmax: return +1
		return 0

# Parameters

t0 = 0.0     # s
dt = 0.001   # s

m  = 1.0     # kg
g  = 9.81    # m/s²
v0 = 0.0     # m/s
x0 = 0.0     # m

t1 =  1.0    # s
t2 =  2.0    # s
t3 =  6.0    # s
t4 =  4.0    # s
t5 = 20.0    # s

F0 =  0.0    # N
F1 = 10.0    # N

us   = 0.50  # ul
uk   = 0.25  # ul
vmax = 0.1   # m/s

N    = m * g # N

# State

t    = t0
x    = x0
v    = v0
a    = None
F    = None
Fapp = None
Ff   = None
mode = None

def do_loop(t_until, handler, printer):
	global t
	
	while t < t_until:
		handler()
		printer()
		t += dt

def do_move(force_finder):
	def handler():
		global x, v, a
		
		force_finder()
		
		a = F / m
		v += a * dt
		x += v * dt
	
	return handler

def slipper(applier):
	slip = Slip(us, uk, vmax)
	
	def force_finder():
		global F, Fapp, Ff, mode
		
		Fapp = applier()
		Ff   = slip.get_force(N, v)
		mode = slip.get_mode(N, v)
		
		F = Fapp + Ff
	
	return force_finder

def applier():
	if t < t1: return F0
	if t < t2: return (t-t1)/(t2-t1)*(F1-F0)
	if t < t3: return F1
	if t < t4: return (t-t3)/(t4-t3)*(F0-F1) + F1
	return F0

# ----------------------------------------------------

def printer():
	print("{0},{1},{2},{3},{4},{5},{6}".format(t, x, v, a, Fapp, Ff, mode))

print("t,x,v,a,Fapp,Ff,mode")
do_loop(t5, do_move(slipper(applier)), printer)
