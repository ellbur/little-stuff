# -*- coding: utf-8 -*-

import re
import datetime

date_pattern = re.compile('\\s*(\\d+-\\d+-\\d+)')

# Nice function to get the date at the head of the story

def get_story_time(filename):
	# Returns it as a datetime object
	
	with open(filename, 'r') as handle:
		
		for line in handle:
			match = re.search(date_pattern, line)
			
			if match:
				date_str = match.group(1)
				date = datetime.datetime.strptime(date_str, '%Y-%m-%d')
				
				return date
		
		else:
			raise RuntimeError('Cannot find date string '
				+ 'in file ' + filename)
