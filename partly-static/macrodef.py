# -*- coding: utf-8 -*-

from macro import *
from mode import *
from lazy import *

class CopyMacro(Macro):
	
	def __init__(self):
		Macro.__init__(self, CopyMacroApply)

class CopyMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(self, *a, **b)
	
	@lazy
	def get_mode(self):
		return self.arg.get_mode()
	
	@lazy
	def tree_apply(self):
		self.tree.add_copies(
			self.arg.node,
			self.ret.node
		)

copy_macro = CopyMacro()

# --------------------------------------------------------------------

class TupleMacro(Macro):
	
	def __init__(self, how):
		Macro.__init__(self, TupleMacroApply)
		self.how = how

class TupleMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(self, *a, **b)
	
	@lazy
	def setup(self):
		how = self.macro.how
		
		self.children = dict()
		
		for name in how:
			parent = how[name]
			child  = self.sl.make_member(self.ret, name)
			
			self.sl.call(copy_macro, parent, child)
			
			self.children[name] = child
	
	def pre_apply(self):
		self.setup()
	
	@lazy
	def get_mode(self):
		field_dict = dict()
		
		for name in self.macro.how:
			
			def lbody(name):
				var = self.macro.how[name]
				rule = laze(lambda: var.get_mode())
				
				field_dict[name] = rule
			
			lbody(name)
		
		return TupleMode(field_dict)
	
	@lazy
	def tree_apply(self):
		pass

def tuple_macro(*a, **b):
	return TupleMacro(*a, **b)

# --------------------------------------------------------------------

class AccessMacro(Macro):
	
	def __init__(self, name):
		Macro.__init__(self, AccessMacroApply)
		self.name = name

class AccessMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(self, *a, **b)
	
	@lazy 
	def get_mode(self):
		return self.arg.get_mode().get_field_mode(self.macro.name)
	
	@lazy
	def tree_apply(self):
		member = self.tree.add_contains(
			self.arg.node,
			self.macro.name
		).get_child()
		
		self.tree.add_copies(member, self.ret.node)

def access_macro(name):
	return AccessMacro(name)

# --------------------------------------------------------------------

class SumMacro(Macro):
	
	def __init__(self):
		Macro.__init__(self, SumMacroApply)

class SumMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(self, *a, **b)
	
	@lazy
	def get_mode(self):
		return float_mode
	
	@lazy
	def tree_apply(self):
		a = self.tree.add_contains(self.arg.node, 'a').get_child()
		b = self.tree.add_contains(self.arg.node, 'b').get_child()
		
		self.tree.add_eats(a, self.ret.node)
		self.tree.add_eats(b, self.ret.node)

sum_macro = SumMacro()

# --------------------------------------------------------------------

class MacroMacro(Macro):
	
	def __init__(self, macro_rule):
		Macro.__init__(self, MacroMacroApply)
		self.macro_rule = macro_rule

class MacroMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(*a, **b)
	
	@lazy
	def get_mode(self):
		return MacroMode(self.macro.macro_rule())
	
	@lazy
	def tree_apply(self):
		pass

def macro_macro(*a, **b):
	return MacroMacro(*a, **b)

# --------------------------------------------------------------------

class UserMacro(Macro):
	
	def __init__(self, sl_rule):
		Macro.__init__(self, UserMacroApply)
		self.sl_rule = sl_rule

class UserMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(self, *a, **b)
	
	@lazy
	def setup(self):
		mode_rule = self.arg.get_mode
		self.sl = self.macro.sl_rule()
		
		self.sl.call(blank_macro(mode_rule), None, self.sl.arg)
	
	@lazy
	def get_mode(self):
		self.setup()
		
		return self.sl.ret.get_mode()
	
	@lazy
	def tree_apply(self):
		self.setup()
		
		tree = self.sl.get_tree()
		self.tree.insert_tree(self.arg.node, self.ret.node, tree)

user_macro = UserMacro

# --------------------------------------------------------------------

class BlankMacro(Macro):
	
	def __init__(self, mode_rule):
		Macro.__init__(self, BlankMacroApply)
		self.mode_rule = mode_rule

class BlankMacroApply(MacroApply):
	
	def __init__(self, *a, **b):
		MacroApply.__init__(self, *a, **b)
	
	@lazy
	def get_mode(self):
		return self.macro.mode_rule()
	
	@lazy
	def tree_apply(self):
		pass

blank_macro = BlankMacro
