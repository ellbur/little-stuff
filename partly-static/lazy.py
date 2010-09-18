# -*- coding: utf-8 -*-

class Lazy:
	
	def __init__(self, f):
		self.f   = f
		self.val = None
	
	def __call__(self, *a, **b):
		if self.val == None:
			self.val = self.f(*a, **b)
		
		return self.val

def wrap(method):
	def foo(*a, **b):
		return method(*a, **b)
	
	return foo

def lazy(f):
	return wrap(Lazy(f))
