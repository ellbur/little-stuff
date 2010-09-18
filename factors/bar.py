# -*- coding: utf-8 -*-

def poly(i):
	return i**2 - i - 1

k = 39
x = poly(k)
print('x = {0}'.format(x))

for i in range(1, k):
	t = poly(i)
	print('{0} {1}'.format(
		t,
		x % t
	))
