# -*- coding: utf-8 -*-

from __future__ import print_function
import sys

def build_tree(elements):
	N = len(elements)
	nodes = [ None ] * N
	
	for i in range(N):
		nodes[i] = TreeNode()
		nodes[i].set_leaf(elements[i])
	
	for i in range(N-1):
		nodes = clump(nodes)
	
	return nodes[0]

def print_tree(root):
	if root.is_leaf:
		print(" {0} ".format(root.leaf_str), end='')
	else:
		print('[ ', end='')
		for child in root.children:
			print_tree(child)
		print(' ]', end='')

def clump(nodes):
	n = len(nodes)
	
	best_rank = -1
	best_i = -1
	best_j = -1
	
	print("Searching for best ranked pair")
	print("Searching {0} nodes".format(n))
	print("Searching {0} pairs".format(n*(n-1)/2))
	
	for i in range(1, n):
		for j in range(i):
			
			rank = assoc_rank(nodes[i], nodes[j])
			
			if rank > best_rank:
				best_i = i
				best_j = j
				best_rank = rank
	
	print("Found rank {0} for {1} and {2}".format(
		best_rank, nodes[best_i], nodes[best_j]))
	
	nodes[best_i].element.was_best(nodes[best_j].element)
	
	if best_rank == -1:
		raise InternalError("best_rank == -1")
	
	nodes2 = [ None ] * (n-1)
	k = 0
	for i in range(n):
		if i==best_i or i==best_j:
			continue
		
		nodes2[k] = nodes[i]
		k += 1
	
	nodes2[k] = TreeNode()
	nodes2[k].set_branch([ nodes[best_i], nodes[best_j] ], best_rank)
	
	return nodes2

class InternalError:
	
	def __init__(self, message):
		self.message = message
	
	def __str__(self):
		return "Internal Error: {0}".format(self.message)

class TreeNode:
	
	def __init__(self):
		self.element = None
		self.is_leaf = 0
	
	def set_leaf(self, element):
		self.element = element
		self.children = [ ]
		self.is_leaf = 1
		
		self.leaf_str = element.get_name()
	
	def set_branch(self, children, rank):
		self.children = children
		self.element  = children[0].element
		self.rank     = rank
		
		for i in range(1, len(children)):
			self.element = self.element.combine(children[i].element)
	
	def __str__(self):
		return "TreeNode({0})".format(str(self.element))
	
	def __repr__(self):
		return str(self)

def assoc_rank(node1, node2):
	return node1.element.strength(node2.element)
