# -*- coding: utf-8 -*-

def base_decompose(x, b):
	l = [ ]
	p = b
	
	while x > 0:
		a = x % p
		x -= a
		l.append(a*b/p)
		p *= b
	
	return l

def base_compose(l, b):
	return sum(l[i]*b**i for i in range(len(l)))

x = 5881 * 7643

for b in range(6704-100, 6704+100):
	l = base_decompose(x, b)
	
	for i in range(1, b):
		
		t = base_compose(l, i)
		
		if x % t == 0:
			print('b={0}, l={1}, i={2}, t={3}, x%b=={4}, x%i=={5}, b%i=={6}'.format(
				b, l, i, t, x%b, x%i, b%i
			))
