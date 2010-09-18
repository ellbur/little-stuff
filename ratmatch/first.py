
def first(s, n):
	
	r = [ None ] * n
	it = iter(s)

	for i in range(n):
		r[i] = next(it)
	
	return r

