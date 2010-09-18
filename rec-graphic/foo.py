# -*- coding: utf-8 -*-

import pygraphviz as pg
import random

graph = pg.AGraph(directed = True)

c = 1
def u():
	global c
	
	c += 1
	
	return 'u' + str(c)

R = random.Random()

nodes = [ ]

shapes = [
	'box',
	'diamond'
]

def add_bunch(N):
	
	for i in range(N):
		shape = R.choice(shapes)
		
		add_node(label=' ', width='0.1', height='0.1', shape=shape)

def add_node(**at):
	n = u()
	
	graph.add_node(n, **at)
	
	if len(nodes) >= 2:
		n1 = R.choice(nodes)
		n2 = R.choice(nodes)
		
		graph.add_edge(n1, n)
		graph.add_edge(n, n2)
	
	nodes.append(n)
	
	return n

def add_text(str):
	return add_node(
		label=str, width='1', height='1', shape='box', penwidth='4'
	)

add_bunch(5)

cs   = add_text('CS')
a111 = add_text('111')
sec  = add_text('Sec')
a30  = add_text('30')

add_bunch(5)

graph.add_edge(cs, a111)
graph.add_edge(a111, sec)
graph.add_edge(sec, a30)

graph.draw('./pic.png', prog='dot')
