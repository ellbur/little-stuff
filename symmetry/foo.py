# This file was *autogenerated* from the file foo.sage.
from sage.all_cmdline import *   # import sage library
_sage_const_1 = Integer(1); _sage_const_4 = Integer(4)#!/usr/bin/env sage
# -*- coding: utf-8 -*-

import sys
sys.path.append('/usr/lib/pymodules/python2.6/')

from sage.all import *
import pygraphviz as pg

N = _sage_const_4 

G = KleinFourGroup()
Elems = G.list()

def label(Elem):
	return str(permutation_action(Elem, range(N)))

def name(Elem):
	return id(Elem)

def i(a):
	return a**(-_sage_const_1 )

global_counter = _sage_const_1 
def u():
	global global_counter
	global_counter += _sage_const_1 
	
	return str(global_counter)

graph = pg.AGraph(directed = True)

for El in Elems:
	graph.add_node(name(El),
		label = label(El)
	)

def link(a, b, color):
	n = u()
	graph.add_node(n, shape='point', width='0', height='0', label='')
	graph.add_edge(name(a), n, color=color)
	graph.add_edge(n, name(b), color=color)

for a in Elems:
	for b in Elems:
		
		if a*b == b*a:
			link(a, b, 'green')
		
		if a*i(b) == b*a:
			link(a, b, 'orange')
		
		if a*b == b*i(a):
			link(a, b, 'blue')
		
		if a*b == i(a)*i(b):
			link(a, b, 'red')

graph.draw('./graph.png', prog='dot')
