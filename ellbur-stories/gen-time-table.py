#!/usr/bin/python
# -*- coding: utf-8 -*-

from get_story_time import *
import time
import optparse

parser = optparse.OptionParser(usage='%prog [file] ...')
options, args = parser.parse_args()

def canon(name):
	name = re.sub('^.*\\/', '', name)
	name = re.sub('\\s', '_', name)
	name = re.sub('\\.[^\\.]*$', '', name)
	
	return name

print('name,time')

for filename in args:
	date = get_story_time(filename);
	seconds = time.mktime(date.timetuple())
	
	print('{0},{1}'.format(canon(filename), seconds))
