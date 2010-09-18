# -*- coding: utf-8 -*-

import random

gene_vec_len = 1000

big_counter = 1

def next_number():
	global big_counter
	
	big_counter += 1
	return big_counter

def make_genes():
	genes = [ None ] * gene_vec_len
	
	for i in range(gene_vec_len):
		genes[i] = [ next_number(), next_number() ]
	
	return genes

class Person:
	
	def __init__(self, name):
		self.name  = name
		self.genes = make_genes()
	
	def inherit(self, a, b):
		
		for i in range(gene_vec_len):
			self.genes[i][0] = random.choice(a.genes[i])
			self.genes[i][1] = random.choice(b.genes[i])
	
	def inherit1(self, a):
		
		for i in range(gene_vec_len):
			self.genes[i][0] = a.genes[i][0]
			self.genes[i][1] = a.genes[i][1]


def related(a, b):
	sum_r = 0.0
	
	for i in range(gene_vec_len):
		sum_r += related_gene(a.genes[i], b.genes[i])
	
	return sum_r / float(gene_vec_len)

def related_gene(g1, g2):
	if (g1[0] == g2[0]) and (g1[1] == g2[1]): return 1.0
	if (g1[1] == g2[0]) and (g1[0] == g2[1]): return 1.0
	if g1[0] == g2[0]: return 0.5
	if g1[0] == g2[1]: return 0.5
	if g1[1] == g2[0]: return 0.5
	if g1[1] == g2[1]: return 0.5
	return 0.0

Chelsea = Person("Chelsea")
Andy    = Person("Andy")
Katie   = Person("Katie")
Elena   = Person("Elena")
Hactar  = Person("Hactar")

for i in range(1000):
	Andy.inherit1(Chelsea)
	Hactar.inherit(Andy, Katie)
	Chelsea.inherit(Elena, Hactar)
	Katie.inherit(Elena, Hactar)

people = [ Chelsea, Andy, Katie, Elena, Hactar ]

for i in range(len(people)):
	for j in range(i, len(people)):
		
		a = people[i]
		b = people[j]
		
		print("{0} <--> {1} : {2}".format(a.name, b.name, related(a,b)))

