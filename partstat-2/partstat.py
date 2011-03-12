# -*- coding: utf-8 -*-

from struct import *
from unique import *

@struct('func', 'arg')
class Call:
	pass

@struct('args')
class Tuple:
	pass

@struct('obj', 'text', 'befs')
class Code:
	pass

var_names = { }

def var(obj):
	if obj in var_names:
		return var_names[obj]
	
	var_names[obj] = 'u' + str(unique())
	return var_names[obj]

class Add:
	
	def inline(res, arg):
		x = (add,arg,'x')
		y = (add,arg,'y')
		
		complete(x)
		complete(y)
		
		res_code = Code(res,
			'auto {0} = {1} + {2};'.format(var(res), var(x), var(y)),
			[ codes[x], codes[y] ]
		)
		codes[res] = res_code

add = Add()

class Literal:
	
	def inline(res, arg):
		
		res_code = Code(res,
			'auto {0} = {1};'.format(var(res), str(res)),
			[ ]
		)
		codes[res] = res_code

literal = Literal()

def clearly_literal(res):
	if type(res) == int:
		return True
	
	return False

def complete_literal(res):
	calls[res] = call(literal, ())

def complete_tuple(res, tuple):
	
	args = tuple.args
	
	# What goes here ??

def complete(res):
	
	if res in tuples:
		T = tuples[res]
		
		complete_tuple(res, T)
	
	elif res in calls:
		C = calls[res]
		
		complete_call(res, C)
	
	elif clearly_literal(res):
		complete_literal(res)
	
	else:
		raise NotPossible

calls  = { }
tuples = { }

codes = { }

tuples['a'] = Tuple([1, 2])
calls['b'] = Call(add, 'a')
