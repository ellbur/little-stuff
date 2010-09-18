# -*- coding: utf-8 -*-

from hash import *

class Mode:
	
	def __init__(self):
		pass
	
	def get_field_mode(self, name):
		raise NotImplementedError

class TupleMode(Mode):
	
	def __init__(self, field_mode_rules):
		Mode.__init__(self)
		
		self.field_mode_rules = field_mode_rules
	
	def get_field_mode(self, name):
		return (self.field_modes[name])()

class MacroMode(Mode):
	
	def __init__(self, macro):
		Mode.__init__(self)
		
		self.macro = macro

class FloatMode(Mode):
	
	def __init__(self):
		Mode.__init__(self)

