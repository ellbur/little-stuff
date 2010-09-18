# -*- coding: utf-8 -*-

def default_hash(object):
	res = 0
	
	for field in object.__dict__:
		res ^= hash(object.__dict__[field])
	
	return res

class EasyHash:
	
	def __hash__(self):
		return default_hash(self)
	
	def __eq__(self, other):
		return self.__dict__ == other.__dict__

class UniqueHash:
	
	def __hash__(self):
		return id(self)
	
	def __eq__(self, other):
		return hash(self) == hash(other)
