# -*- coding: utf-8 -*-

class Lazy:
	
	def __init__(self, f):
		self.f   = f
		self.val = None
	
	def __call__(self, *a, **b):
		if self.val == None:
			self.val = self.f(*a, **b)
		
		return self.val

class A:
	
	def __init__(self):
		self.a = 5
	
	@Lazy
	def foo(self):
		print("A.foo")
		return self.a
	
	def bar(self):
		print("A.bar")
		return self.a

a = A()

