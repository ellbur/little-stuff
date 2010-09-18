# -*- coding: utf-8 -*-

from deptree import *
from lazy import *

class StatementList:
	
	def __init__(self):
		self.variables  = [ ]
		self.statements = [ ]
		
		self.arg = None
		self.ret = None
		
		self.tree = DepTree(setup=False)
	
	def make_var(self):
		v = Variable(self)
		v.node = self.tree.make_node()
		v.node.var = v
		
		self.variables.append(v)
		
		return v
	
	def make_member(self, parent, name):
		v = self.make_var()
		self.tree.add_contains(parent.node, name, v.node)
		
		return v
	
	def call(self, macro, arg, ret=None):
		if ret == None:
			ret = self.make_var()
		
		macro_apply = macro.apply(self, self.tree, arg, ret)
		
		st = CallStatement(macro_apply)
		self.statements.append(st)
		
		ret.statement = st
		
		return ret
	
	def var_call(self, car, cdr, ret=None):
		car_mode = car.get_mode()
		macro = car_mode.get_macro(car, cdr)
		
		ret = self.call(macro, cdr, ret)
		
		tree.add_eats(car.node, ret.node)
	
	@lazy
	def pre_apply(self):
		for st in self.statements:
			st.pre_apply()
	
	@lazy
	def get_tree(self):
		self.pre_apply()
		
		for st in self.statements:
			st.tree_apply()
		
		return self.tree
	
	@lazy
	def finish(self):
		for st in self.statements:
			st.post_apply()
	
	def set_arg(self, var):
		self.arg = var
		self.tree.set_arg(var.node)
	
	def set_ret(self, var):
		self.ret = var
		self.tree.set_ret(var.node)

class Variable:
	
	def __init__(self, statement_list):
		self.statement_list = statement_list
		self.statement = None
	
	def make_arg(self):
		self.statement_list.set_arg(self)
	
	def make_ret(self):
		self.statement_list.set_ret(self)
	
	def get_mode(self):
		if self.statement == None:
			raise RuntimeError
		
		return self.statement.get_mode()

class Statement:
	
	def __init__(self, ret):
		self.ret = ret
	
	def get_ret(self):
		return self.ret
	
	def pre_apply(self):
		pass
	
	def tree_apply(self):
		raise NotImplementedError
	
	def post_apply(self):
		pass
	
	def get_mode(self):
		raise NotImplementedError

class CallStatement(Statement):
	
	def __init__(self, macro_apply):
		Statement.__init__(self, macro_apply.ret)
		self.macro_apply = macro_apply
	
	def pre_apply(self):
		self.macro_apply.pre_apply()
	
	def tree_apply(self):
		self.macro_apply.tree_apply()
	
	def get_mode(self):
		return self.macro_apply.get_mode()
	
	def post_apply(self):
		self.macro_apply.post_apply()


