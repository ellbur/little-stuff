#!/usr/bin/python
# -*- coding: utf-8 -*-

from columns    import *
from grouping   import *
from data       import *
from functions  import *
from builtins   import *

def python_to_chuck(obj):
	
	cell = Cell()
	cell.is_null = False
	
	if obj == None:
		cell = no_data('null')
	
	elif isinstance(obj, int):
		cell.data_type = int_type
		cell.value     = obj
	
	elif isinstance(obj, str):
		cell.data_type = string_type
		cell.value     = obj
	
	elif isinstance(obj, float):
		cell.data_type = float_type
		cell.value     = obj
	
	elif isinstance(obj, list):
		cell = make_column(obj)
	
	return cell

def make_column(enumerable):
	
	col = Column()
	
	for key, value in enumerate(enumerable):
		col.rows[key] = python_to_chuck(value)
	
	return col

foo = python_to_chuck([1, 2, 3, 4, 5, 6])
bar = python_to_chuck([0, 1, 0, 1, 0, 1])

baz = python_to_chuck([1, 2, 3, 4])
qux = python_to_chuck([2, 2, 2, 8])

print foo
print bar

print exact_lineup(qux, baz, foo)

def chuck_sum_handler(context):
	p1 = context.parameters[0].value
	
	print "arg is ", p1.value
	
	ret = Cell()
	ret.data_type = float_type
	
	total = 0
	for key,elem in p1.value.iteritems():
		print "elem is", elem
		
		if not elem.is_null:
			total += elem.value
		
		ret.inherit(elem)
	
	ret.value = total
	context.retval = ret

chuck_sum = Builtin_Function()
chuck_sum.handler = chuck_sum_handler
chuck_sum.name = 'sum'

arg1 = Function_Arg
arg1.name          = 'x'
arg1.default       = None
arg1.may_broadcast = True

chuck_sum.args = [ arg1 ]

context = Function_Call_Context

param1 = Function_Parameter()
param1.arg           = arg1
param1.value         = group(foo, bar)
param1.may_broadcast = True

context.function   = chuck_sum
context.parameters = [ param1 ]

function_broadcast(context)

print context.retval
