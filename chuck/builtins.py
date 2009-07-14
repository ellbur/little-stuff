#!/usr/bin/python
# -*- coding: utf-8 -*-

from functions import *

class Builtin_Function(Function):
	
	def __init__(self):
		Function.__init__(self)
		
		self.handler = None
	
	def call(self, context):
		self.handler(context)


