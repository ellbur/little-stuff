# -*- coding: utf-8 -*-

import sys
sys.path.append('/usr/lib/pymodules/python2.6/')

from sage.all import *

cyclic_order_table = { }

def all_cyclic_orders(n):
	# Generate the orders of all elements of the cyclic
	# group of order n.
	
	global cyclic_order_table
	
	if n in cyclic_order_table:
		return cyclic_order_table[n]
	
	if n == 1:
		return [ 1 ]
	
	orders = [ 0 ] * n
	orders[0] = 1
	orders[1] = n
	
	for i in range(2, n):
		
		if orders[i] != 0: continue
		
		cycle = [ 0 ]
		t = i
		
		while t != 0:
			cycle.append(t)
			t = (i + t) % n
		
		k = len(cycle)
		orders[i] = k
		if k < n:
			
			sub_orders = all_cyclic_orders(k)
			for j in range(k):
				orders[cycle[j]] = sub_orders[j]
	
	cyclic_order_table[n] = orders
	
	return orders

def walk_cycle(G, a):
	
	id = G.identity()
	
	cycle = [ id ]
	p = a
	while p != id:
		cycle.append(p)
		p = a * p
	
	return cycle

def all_orders(G):
	# Find the order of all elements.
	# All elements must have finite order.
	
	orders = { }
	
	els = G.list()
	
	for a in els:
		
		if a in orders:
			continue
		
		cycle = walk_cycle(G, a)
		k = len(cycle)
		
		cycle_orders = all_cyclic_orders(k)
		
		for i in range(k):
			orders[cycle[i]] = cycle_orders[i]
	
	return orders
