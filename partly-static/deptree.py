# -*- coding: utf-8 -*-

class DepTree:
	
	def __init__(self, setup=True):
		
		if setup:
			self.arg = DepNode()
			self.ret = DepNode()
			
			self.nodes = [ self.arg, self.ret ]
		else:
			self.arg = None
			self.ret = None
			
			self.nodes = [ ]
		
		self.copies   = [ ]
		self.eats     = [ ]
		self.contains = [ ]
	
	def get_arg(self):
		return self.arg
	
	def get_ret(self):
		return self.ret
	
	def set_arg(self, arg):
		self.arg = arg
	
	def set_ret(self, ret):
		self.ret = ret
	
	def get_nodes(self):    return self.nodes
	def get_contains(self): return self.contains
	def get_copies(self):   return self.copies
	def get_eats(self):     return self.eats
	
	def add_node(self):
		node = DepNode()
		self.nodes.append(node)
		
		return node
	
	def make_node(self):
		return self.add_node()
	
	def add_contains(self, node, name, child=None):
		
		already = list(c for c in self.contains if
			c.get_parent() == node and
			c.get_name()   == name
		)
		
		if len(already) > 0: return already[0]
		
		if child==None:
			child = self.add_node()
		
		contains = DepContains(node, child, name)
		self.contains.append(contains)
		
		parents = list(c.get_parent() for c in self.copies if
			c.get_child() == node
		)
		for parent in parents:
			self.add_copies(self.add_contains(parent, name).get_child(), child)
		
		descendents = (c.get_child() for c in self.copies if
			c.get_parent() == node
		)
		for descendent in descendents:
			self.add_copies(child, self.add_contains(descendent, name).get_child())
		
		eaters = list(e.get_child() for e in self.eats if
			e.get_parent() == node
		)
		for eater in eaters:
			self.add_eats(child, eater)
		
		return contains
	
	def add_copies(self, parent, child):
		
		already = list(c for c in self.copies if
			c.get_parent() == parent and
			c.get_child()  == child
		)
		
		if len(already) > 0: return already[0]
		
		copies = DepCopies(parent, child)
		self.copies.append(copies)
		
		child_members = (c for c in self.contains if
			c.get_parent() == child
		)
		parent_members = (c for c in self.contains if
			c.get_parent() == parent
		)
		
		for child_member in child_members:
			parent_member = self.add_contains(parent, child_member.get_name())
			self.add_copies(parent_member.get_child(), child_member.get_child())
		
		for parent_member in parent_members:
			child_member = self.add_contains(child, parent_member.get_name())
			self.add_copies(parent_member.get_child(), child_member.get_child())
		
		return copies
	
	def add_eats(self, parent, child):
		
		already = list(e for e in self.eats if
			e.get_parent() == parent and
			e.get_child()  == child
		)
		
		if len(already) > 0: return already[0]
		
		eats = DepEats(parent, child)
		self.eats.append(eats)
		
		parent_members = (c for c in self.contains if
			c.get_parent() == parent
		)
		
		for parent_member in parent_members:
			self.add_eats(parent_member.get_child(), child)
		
		return eats
	
	def insert_tree(self, parent, child, tree):
		
		# Ensure all new nodes
		tree = tree.copy()
		
		self.nodes    += tree.nodes
		self.contains += tree.contains
		self.copies   += tree.copies
		self.eats     += tree.eats
		
		self.add_copies(parent, tree.arg)
		self.add_copies(tree.ret, child)
	
	def copy(self):
		node_map = dict()
		
		for node in self.nodes:
			node_map[node] = DepNode()
		
		tree = DepTree(setup=False)
		
		for node in self.nodes:
			tree.nodes.append(node_map[node])
		
		for contains in self.contains:
			tree.contains.append(DepContains(
				node_map[contains.get_parent()],
				node_map[contains.get_child()],
				contains.name
			))
		
		for copies in self.copies:
			tree.copies.append(DepCopies(
				node_map[copies.get_parent()],
				node_map[copies.get_child()]
			))
		
		for eats in self.eats:
			tree.eats.append(DepEats(
				node_map[eats.get_parent()],
				node_map[eats.get_child()]
			))
		
		tree.arg = node_map[self.arg]
		tree.ret = node_map[self.ret]
		
		return tree

class DepNode:
	
	counter = 0
	
	def __init__(self):
		self.id = 'n{0}'.format(DepNode.counter)
		
		DepNode.counter += 1
	
	def get_id(self): return self.id
	
	def __eq__(self, other):
		return id(self) == id(other)
	
	def __hash__(self):
		return hash(self.id)

class DepContains:
	
	def __init__(self, parent, child, name):
		self.parent = parent
		self.child  = child
		self.name   = name
	
	def get_parent(self): return self.parent
	def get_child(self):  return self.child
	def get_name(self):   return self.name


class DepCopies:
	
	def __init__(self, parent, child):
		self.parent = parent
		self.child  = child
	
	def get_parent(self): return self.parent
	def get_child(self):  return self.child

class DepEats:
	
	def __init__(self, parent, child):
		self.parent = parent
		self.child  = child
	
	def get_parent(self): return self.parent
	def get_child(self):  return self.child

