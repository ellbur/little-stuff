# -*- coding: utf-8 -*-

class Macro:
	
	def __init__(self, apply_class):
		self.apply_class = apply_class
	
	def apply(self, sl, tree, arg, ret):
		return self.apply_class(self, sl, tree, arg, ret)

class MacroApply:
	
	def __init__(self, macro, sl, tree, arg, ret):
		self.macro = macro
		self.sl    = sl
		self.tree  = tree
		self.arg   = arg
		self.ret   = ret
	
	def pre_apply(self):
		pass
	
	def get_mode(self):
		raise NotImplementedError
	
	def tree_apply(self):
		raise NotImplementedError
	
	def post_apply(self):
		pass
