# -*- coding: utf-8 -*-

class Chrome:
	
	def __init__(self, name):
		self.name  = name
		self.group = 0
		self.links = [ ]
	
	def clear(self):
		self.group = 0
		self.links = [ ]
	
	def flood(self, group):
		if self.group != 0: return
		
		self.group = group
		for l in self.links: l.flood(group)

class Person:
	
	def __init__(self, name):
		self.name = name
		
		self.c1 = Chrome(name[0] + '1')
		self.c2 = Chrome(name[0] + '2')
	
	def __str__(self):
		return name

class Descent:
	
	def __init__(self, p1, p2, c):
		self.p1 = p1
		self.p2 = p2
		self.c  = c
	
	def apply_links(self, choice1, choice2):
		if not choice1: link(self.c.c1, self.p1.c1)
		else:       link(self.c.c1, self.p1.c2)
		if not choice2: link(self.c.c2, self.p2.c1)
		else:       link(self.c.c2, self.p2.c2)

def related(p1, p2):
	if p1.c1.group == p2.c1.group and p1.c2.group == p2.c2.group: return 1.0
	if p1.c2.group == p2.c1.group and p1.c1.group == p2.c2.group: return 1.0
	if p1.c1.group == p2.c1.group: return 0.5
	if p1.c2.group == p2.c1.group: return 0.5
	if p1.c1.group == p2.c2.group: return 0.5
	if p1.c2.group == p2.c2.group: return 0.5
	return 0.0

def link(c1, c2):
	c1.links.append(c2)
	c2.links.append(c1)

def link_all(choices):
	for i in range(len(descents)):
		d = descents[i]
		
		c1 = choices[2*i + 0]
		c2 = choices[2*i + 1]
		
		d.apply_links(c1, c2)

def clear_all():
	for c in chromes: c.clear()

def flood_all():
	group_counter = 0
	
	for c in chromes:
		if c.group == 0:
			group_counter += 1
			c.flood(group_counter)

people   = [ ]
chromes  = [ ]
descents = [ ]

def make_person(name):
	p = Person(name)
	
	people.append(p)
	chromes.append(p.c1)
	chromes.append(p.c2)
	
	return p

def mp(name): return make_person(name)

def make_descent(p1, p2, c):
	descents.append(Descent(p1, p2, c))

def md(p1, p2, c): return make_descent(p1, p2, c)

def print_status():
	for p in people:
		print("{0}: {1} {2}".format(p.name, p.c1.group, p.c2.group))

Andy   = mp('Andy')
Katie  = mp('Katie')
Elena  = mp('Elena')
Hactar = mp('Hactar')

md(Andy,   Katie,  Hactar)
md(Elena,  Hactar, Andy)
md(Elena,  Hactar, Katie)

def test_bit(bits):
	if len(bits) >= 2*len(descents):
		test_choices(bits)
		return
	
	b1 = list(bits)
	b2 = list(bits)
	
	b1.append(0)
	b2.append(1)
	
	test_bit(b1)
	test_bit(b2)

related_sums  = dict()
related_count = 0

for i in range(len(people)):
	for j in range(len(people)):
		related_sums[(i,j)] = 0.0

def test_choices(bits):
	global related_sums
	global related_count
	
	link_all(bits)
	flood_all()
	
	print("")
	print("")
	print_status()
	print("")
	
	for i in range(len(people)):
		for j in range(i, len(people)):
			a = people[i]
			b = people[j]
			
			r = related(a, b)
			
			related_sums[(i,j)] += r
			
			print("{0} <--> {1} {2}".format(a.name, b.name, r))
	
	related_count += 1
	
	clear_all()

test_bit([])

print("")
print("-----------------------------------------")
print("")

for i in range(len(people)):
	for j in range(i, len(people)):
		
		a = people[i]
		b = people[j]
		
		r = related_sums[(i,j)] / related_count
		
		print("{0} <--> {1} {2}".format(a.name, b.name, r))
