# -*- coding: utf-8 -*-

from deptreevis import *
from deptree import *
from eval import *
from macrodef import *

def make_foo():
	sl = StatementList()
	
	arg = sl.make_var()
	ret = sl.call(access_macro('b'), arg)
	
	arg.make_arg()
	ret.make_ret()
	
	return user_macro(lambda:sl)

def make_bar(foo):
	
	sl = StatementList()
	
	arg = sl.make_var()
	b = sl.call(access_macro('x'), arg)
	clo = sl.call(tuple_macro({'b':b}), None)
	a = sl.call(foo, clo)
	ret = sl.call(copy_macro, a)
	
	arg.make_arg()
	ret.make_ret()
	
	return sl

sl = make_bar(make_foo())

tree = sl.get_tree()

graph = deptree_make_graph(tree)
graph.draw('foo.png', prog='dot')
