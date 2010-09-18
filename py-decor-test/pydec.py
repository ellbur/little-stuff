# -*- coding: utf-8 -*-

def wrap(method):
	def foo(*a, **b):
		return method(*a, **b)
	
	return foo

class Lazy:
	
	def __init__(self, f):
		self.f   = f
		self.val = None
	
	def __call__(self, *a, **b):
		if self.val == None:
			self.val = self.f(*a, **b)
		
		return self.val

def lazy(f):
	return wrap(Lazy(f))


class A:
	
	def __init__(self):
		self.a = 5
	
	@lazy
	def foo(self):
		print("A.foo")
		return self.a
	
	def bar(self):
		print("A.bar")
		return self.a

a = A()

print(a.foo)
print(a.bar)

print(a.foo())
print(a.bar())
