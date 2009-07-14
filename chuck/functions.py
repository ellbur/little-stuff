#!/usr/bin/python
# -*- coding: utf-8 -*-

from data    import *
from columns import *

class Function:
	
	def __init__(self):
		self.name     = 'noname'
		self.args     = [ ]
	
	def call(self, context):
		# This should be done post broadcasting,
		# So that the function will only be called once, and only
		# give one return value
		
		# The return value is stored in `context`
		
		# This method will be implemented by a subclass
		
		None

class Function_Arg:
	
	def __init__(self):
		self.name          = 'noname'
		self.default       = None
		self.may_broadcast = False

class Function_Parameter:
	
	def __init__(self):
		self.arg           = None
		self.value         = None
		self.may_broadcast = False

class Function_Call_Context:
	
	def __init__(self):
		self.function   = None
		self.parameters = None
		self.retval     = None

class Missing_Function_Argument:
	
	def __init__(self, function, arg):
		self.function = function
		self.arg      = arg

class Extra_Function_Argument:
	
	def __init__(self, function, name, value):
		self.function = function
		self.name     = name
		self.value    = value

def function_broadcast(context):
	
	function = context.function
	params   = context.parameters
	
	broadcast_mask = [False] * len(params)
	broadcast_keys = set()
	any_broadcast  = False
	
	for i,param in enumerate(params):
		
		a = param.may_broadcast
		b = function.args[i].may_broadcast
		c = param.value.data_type == column_type
		
		if a and b and c:
			broadcast_mask[i] = True
			broadcast_keys   |= set(param.value.rows.keys())
			any_broadcast     = True
	
	if not any_broadcast:
		function.call(context)
		return
	
	context.retval = Column()
	
	for key in broadcast_keys:
		
		subcontext = Function_Call_Context()
		subcontext.function = function
		subcontext.parameters = [None] * len(params)
		
		for i,param in enumerate(params):
			
			if broadcast_mask[i]:
				p = Function_Parameter()
				
				p.arg           = param.arg
				p.value         = param.value.get_row(key)
				p.may_broadcast = False
				
				subcontext.parameters[i] = p
				
			else:
				subcontext.parameters[i] = param
		
		function.call(subcontext)
		context.retval.rows[key] = subcontext.retval


