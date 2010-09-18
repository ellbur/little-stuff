#!/usr/bin/python
# -*- coding: utf-8 -*-

import word_blocks
import phylogeny
import random

class NameBunch:
	
	def __init__(self, all_blocks):
		self.all_blocks = all_blocks
		self.block_set  = None
		self.names      = None
		self.N          = None
	
	def set_leaf(self, name, blocks, weight):
		self.block_set  = set()
		self.names      = set([name])
		self.N          = len(blocks)
		
		for i in range(len(blocks)):
			block = blocks[i]
			
			if block.has(name):
				self.block_set.add(i)
		
		self.weight = weight
	
	def set_branch(self, b1, b2):
		self.block_set = set()
		self.block_set.update(b1.block_set)
		self.block_set.update(b2.block_set)
		
		self.names = set()
		self.names.update(b1.names)
		self.names.update(b2.names)
		
		self.N = b1.N
	
	def strength(self, other):
		together = self.block_set.intersection(other.block_set)
		
		t1 = len(self.block_set)
		t2 = len(other.block_set)
		t12 = len(together)
		
		if t1==0 or t2==2:
			return 0
		
		return t12*1.0 / (t1 * t2) * self.N
	
	def was_best(self, other):
		together = self.block_set.intersection(other.block_set)
		t12 = len(together)
		
		print("{0} and {1} appear together in {2} blocks.".format(
			self, other, t12))
		
		if t12 > 0:
			pick_num   = random.choice(list(together))
			pick_block = self.all_blocks[pick_num]
			
			print("For example,")
			print("{0}".format(pick_block.text))
	
	def combine(self, other):
		bunch = NameBunch(self.all_blocks)
		bunch.set_branch(self, other)
		
		return bunch
	
	def get_name(self):
		for name in self.names:
			return name
	
	def __str__(self):
		return "{0} ({1})".format(self.names, len(self.block_set))
	
	def __repr__(self):
		return str(self)

