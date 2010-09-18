# -*- coding: utf-8 -*-

from __future__ import print_function
from math import *
import numpy

class Sim:
	
	def __init__(self, dt=None):
		
		self.signals = [ ]
		self.dt      = dt
		self.t       = Integrator(self, lambda:1, lambda:self.dt())
	
	def add_signal(self, sig):
		self.signals.append(sig)
	
	def step(self):
		for sig in self.signals:
			sig.step()

class Signal:
	
	def __init__(self, keeper, rule=None, value=None):
		self.rule  = rule
		self.value = value
		
		keeper.add_signal(self)
	
	def __call__(self):
		return self.value
	
	def step(self):
		self.value = self.rule()
	
	def init(self, value):
		self.value = value

class Adder(Signal):
	
	def __init__(self, keeper, addends=[]):
		Signal.__init__(self, keeper, lambda : self.get_sum(), 0)
		
		self.addends = addends
	
	def get_sum(self):
		return sum(map(apply, self.addends))

class Negator(Signal):
	
	def __init__(self, keeper, sig=None):
		Signal.__init__(self, keeper, lambda : self.get_negation(), 0)
		
		self.sig = sig
	
	def get_negation(self):
		return -self.sig()

class Scale(Signal):
	
	def __init__(self, keeper, k, sig=None):
		Signal.__init__(self, keeper, lambda : self.get_scale(), 0)
		
		self.k  = k
		self.sig = sig
	
	def get_scale(self):
		return self.k * self.sig()

class Integrator(Signal):
	
	def __init__(self, keeper, sig=None, dt=None):
		Signal.__init__(self, keeper)
		
		self.sig    = sig
		self.dt     = dt
		self.total  = 0
		self.value  = 0
	
	def get_integral(self):
		return self.total
	
	def step(self):
		self.total += self.sig() * self.dt()
		self.value = self.total
	
	def init(self, value):
		self.value = value
		self.total = value

class Interp(Signal):
	
	def __init__(self, keeper, tvec, yvec, t=None):
		Signal.__init__(self, keeper, lambda : self.get_interp(), 0)
		
		self.tvec = tvec
		self.yvec = yvec
		self.t    = t
	
	def get_interp(self):
		return numpy.interp(self.t(), self.tvec, self.yvec)

class Slipper(Signal):
	
	def __init__(self, keeper, us, uk, vmax, N=None, v=None):
		Signal.__init__(self, keeper, lambda : self.get_value(), None)
		
		self.us   = us
		self.uk   = uk
		self.vmax = vmax
		
		self.N = N
		self.v = v
		
		self.F = Signal(keeper, lambda:self.get_force(), 0)
		self.mode = Signal(keeper, lambda:self.get_mode(), 0)
	
	def get_value(self):
		return Struct(F=self.get_force(), mode=self.get_mode())
	
	def get_force(self):
		N = self.N()
		v = self.v()
		
		if N <= 0: return 0
		
		if v < -self.vmax: return +self.uk * N
		if v > +self.vmax: return -self.uk * N
		
		return -self.us*N / self.vmax * v
		
	def get_mode(self):
		v = self.v()
		
		if v < -self.vmax: return -1
		if v > +self.vmax: return +1
		return 0

class RigidBody1D(Signal):
	
	def __init__(self, keeper, m, forces=[], dt=None):
		Signal.__init__(self, keeper, lambda : self.get_value(), None)
		
		self.m      = m
		self.forces = forces
		self.dt     = dt
		
		self.F = Signal(keeper, lambda:self.get_force(), 0.0)
		self.a = Scale(keeper, 1.0/m, self.F)
		self.v = Integrator(keeper, self.a, lambda:self.dt())
		self.x = Integrator(keeper, self.v, lambda:self.dt())
	
	def get_value(self):
		return Struct(
			F = self.get_force(),
			a = self.a(),
			v = self.v(),
			x = self.x())
	
	def get_force(self):
		return sum(map(apply, self.forces))

class Motor(Signal):
	
	def __init__(self, keeper, max_stall_torque, max_speed,
		level=None, speed=None
	):
		Signal.__init__(self, keeper, lambda : self.get_torque(), 0)
		
		self.max_stall_torque = max_stall_torque
		self.max_speed = max_speed
		
		self.level  = level
		self.speed  = speed
		self.torque = Signal(keeper, lambda:self.get_torque(), 0)
	
	def get_torque(self):
		level = self.level()
		speed = self.speed()
		
		max_stall_torque = self.max_stall_torque
		max_speed        = self.max_speed
		
		stall_torque = max_stall_torque * level
		top_speed    = max_speed * level
		
		if abs(top_speed)*1.0e5 <= abs(speed):
			return -speed * max_stall_torque / max_speed
		
		return (top_speed-speed)/top_speed * stall_torque

class Wheel1D(Signal):
	
	def __init__(self, keeper, slip, drive, rad, I, v=None, dt=None):
		Signal.__init__(self, keeper, lambda:self.F(), 0.0)
		
		self.slip  = slip
		self.drive = drive
		self.rad   = rad
		self.I     = I
		self.v     = v
		self.dt    = dt
		
		self.alpha = Signal(keeper, lambda:
			(self.drive.torque() + self.slip.F()*self.rad) / self.I, 0.0)
		
		self.omega = Integrator(keeper, lambda:self.alpha(), lambda:self.dt())
		self.vb = Signal(keeper, lambda:self.v() + self.rad*self.omega(), 0.0)
		self.F = self.slip.F
		
		drive.speed = self.omega
		slip.v = self.vb

# Little hack
# http://norvig.com/python-iaq.html

class Struct:
	def __init__(self, **entries): self.__dict__.update(entries)
