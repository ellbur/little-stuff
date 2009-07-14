#!/usr/bin/python
# -*- coding: utf-8 -*-

class Data_Type:
	
	def __init__(self):
		self.name    = ''
		self.methods = { }
	
	def key_form(self, cell):
		return cell.value
	
	def copy(self, cell):
		new = Cell()
		
		new.data_type = self
		new.flags     = cell.flags.copy()
		new.is_null   = cell.is_null
		new.value     = cell.value
		
		return new

null_type = Data_Type()
null_type.name = 'null'

def no_data(reason):
	cell = Cell()
	cell.data_type = null_type
	cell.is_null   = True
	
	cell.flag(reason)
	
	return cell

int_type = Data_Type()
int_type.name = 'int'

float_type = Data_Type()
float_type.name = 'float'

bool_type = Data_Type()
bool_type.name = 'bool'

string_type = Data_Type()
string_type.name = 'string'

class Cell:
	
	def __init__(self):
		self.data_type = None
		self.value     = None
		self.flags     = set()
		self.is_null   = True
	
	def flag(self, text):
		self.flags.add(text)
	
	def inherit(self, other):
		self.flags   |= other.flags
		self.is_null |= other.is_null
	
	def key_form(self):
		return self.data_type.key_form(self)
	
	def get_row(self, key):
		return value
	
	def __str__(self):
		return "cell(" + str(self.value) + ")"
	
	def __repr__(self):
		return "cell(" + repr(self.value) + ")"
	
	def copy(self):
		return self.data_type.copy(self)

