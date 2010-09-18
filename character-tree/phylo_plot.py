# -*- coding: utf-8 -*-

from __future__ import print_function
import phylogeny
import pygraphviz as pgv

def graph_tree(root):
	return Grapher(root).graph

class Grapher:
	
	def __init__(self, root):
		self.root = root
		self.graph = pgv.AGraph(directed=True)
		self.node_number = 0
		self.branches = [ ]
		self.leaves   = [ ]
		
		self.find_nodes(root)
		
		rank_list = [ (n.rank, n) for n in self.branches ]
		rank_list.sort()
		for i in range(len(rank_list)):
			rank_list[i][1].rank_order = i*1.0 / len(rank_list)
		
		weights = [ n.weight*1.0 for n in self.leaves ]
		mean_weight = sum(weights) / len(weights)
		
		if mean_weight == 0:
			print("WARNING: mean weight is ZERO")
			mean_weight = 1
		
		for i in range(len(self.leaves)):
			self.leaves[i].weight_index = weights[i] / mean_weight
		
		self.add_node(root)
	
	def find_nodes(self, node):
		if node.is_leaf:
			self.leaves.append(node)
		
		else:
			self.branches.append(node)
			for child in node.children:
				self.find_nodes(child)
	
	def rank_size(self, node):
		f = node.rank_order
		return 0.05 + (1-f)*0.5
	
	def weight_size(self, node):
		f = node.weight_index
		return 8.0 + 20.0*f
	
	def add_node(self, node):
		if node.is_leaf:
			name = node.leaf_str
			size = self.weight_size(node)
			
			self.graph.add_node(name, shape='plaintext',
				fontsize=str(size))
		
		else:
			name = str(self.node_number)
			self.node_number += 1
			
			size = self.rank_size(node)
			
			self.graph.add_node(name, shape='circle',
				label=' ', fontsize='0', width=str(size), height=str(size),
				fixedsize='true')
			
			self.add_children(node, name)
		
		return name
	
	def add_children(self, node, name):
		
		for child in node.children:
			cname = self.add_node(child)
			self.graph.add_edge(name, cname, arrowhead='none')
