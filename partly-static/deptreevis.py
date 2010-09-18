# -*- coding: utf-8 -*-

from deptree import *
from pygraphviz import *

def deptree_make_graph(deptree):
	
	graph = AGraph(directed=True)
	
	for node in deptree.get_nodes():
		label = '{0}'.format(node.get_id())
		width = '1'
		
		if node == deptree.get_arg() or node == deptree.get_ret():
			width = '3'
		
		graph.add_node(id(node), label=label, penwidth=width)
	
	for contains in deptree.get_contains():
		graph.add_edge(
			id(contains.get_parent()),
			id(contains.get_child()),
			label=contains.get_name(),
			color='red'
		)
	
	for copies in deptree.get_copies():
		graph.add_edge(
			id(copies.get_parent()),
			id(copies.get_child()),
			color='black',
			penwidth='3'
		)
	
	for eats in deptree.get_eats():
		graph.add_edge(
			id(eats.get_parent()),
			id(eats.get_child()),
			color='black'
		)
	
	return graph
