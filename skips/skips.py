# -*- coding: utf-8 -*-

from prettytable import PrettyTable

def print_matrix(array, rownames=None, colnames=None):
	
	n = len(array)
	m = len(array[0])
	
	if rownames == None:
		rownames = map(str, range(n))
	
	if colnames == None:
		colnames = map(str, range(m))
	
	tab = PrettyTable([''] + colnames)
	
	for i in range(n):
		tab.add_row([rownames[i]] + array[i])
	
	tab.printt(border = False)

def compose(t1, t2):
	return tuple(t2[t1[j]] for j in range(len(t1)))

def maps_1(n):
	return [
			tuple(j for j in range(n+1) if j!= k)
		for k in range(n+1)
	]

n = 3

m1 = maps_1(n)
m2 = maps_1(n+1)

matrix = [ [ None for j in range(n+1) ] for i in range(n+2) ]
m3set = set([])

for i in range(n+2):
	for j in range(n+1):
		
		matrix[i][j] = compose(m1[j], m2[i])
		m3set.add(matrix[i][j])

print('')
print_matrix(matrix)
print('')
print('size = {0}'.format(len(m3set)))
print('')
