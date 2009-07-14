#!/usr/bin/python
# -*- coding: utf-8 -*-

from columns import *

def group(col, by):
	# col and by must have the same keys
	
	res = Column()
	
	for key,byval in by.rows.iteritems():
		
		keyform = byval.key_form()
		
		group = None
		
		if not(keyform in res.rows):
			group = Column()
			res.rows[keyform] = group
		else:
			group = res.rows[keyform]
		
		group.rows[key] = col.rows[key]
	
	return res

def index(col, by):
	# The keys of col correspond to the values of by
	#
	# As in a:b c:a
	
	res = Column()
	
	for key,group in by.rows.iteritems():
		
		paired = Column()
		
		for groupi,byval in group.rows.iteritems():
			paired.rows[groupi] = col.get_row(byval.key_form())
		
		res.rows[key] = paired
	
	return res

def select_first(col):
	# Converts groups to single elements by
	# picking one arbitrarily
	
	res = Column()
	
	for key,value in col.rows.iteritems():
		
		if value.data_type == column_type:
			the_list = value.value.values() # oh dear
			
			if len(the_list) > 0:
				res.rows[key] = the_list[0]
			else:
				res.rows[key] = no_data('empty')
		else:
			res.rows[key] = value
	
	return res

def reindex(values, key):
	return select_first(group(values, key))

def exact_lineup(values, oldkey, newkey):
	return select_first(select_first(
		index(group(values, oldkey), group(newkey, newkey))))
