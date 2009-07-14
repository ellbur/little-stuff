#!/usr/bin/python
# -*- coding: utf-8 -*-

from data import *

class Column_Type(Data_Type):
	
	def __init__(self):
		Data_Type.__init__(self)
		
		self.name = 'column'
	
	def copy(self, cell):
		new = Column()
		
		new.data_type = self
		new.flags     = cell.flags.copy()
		new.is_null   = cell.is_null
		
		for key,value in cell.rows.iteritems():
			new.rows[key] = value.copy()
		
		return new
	
	def key_form(self, cell):
		return tuple(cell.rows.values())

column_type = Column_Type()

class Column(Cell):
	
	def __init__(self):
		self.rows      = { }
		self.value     = self.rows
		self.data_type = column_type
	
	def get_row(self, row):
		
		if row in self.rows:
			return self.rows[row]
		
		else:
			return no_data('row not present')

