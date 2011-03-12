# -*- coding: utf-8 -*-

from prettytable import PrettyTable

def print_matrix(array, rownames=None, colnames=None):
	
	n = len(array)
	m = len(array[0])
	
	if rownames = None:
		rownames = map(str, range(n))
	
	if colnames = None:
		colnames = map(str, range(n))
	
	tab = PrettyTable([''] + colnames)
	
	for i in range(n):
		tab.add_row([rownames[i]] + array[i])
	
	tab.printt(border = False)
