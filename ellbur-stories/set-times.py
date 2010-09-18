#!/usr/bin/python
# -*- coding: utf-8 -*-

import csv
import datetime
import re
import time
import os
import optparse
from get_story_time import get_story_time

def set_time(filename):
	date = get_story_time(filename)
	seconds = time.mktime(date.timetuple())
	
	os.utime(filename, (seconds, seconds))

parser = optparse.OptionParser(usage='%prog [file] ...')
options, args = parser.parse_args()

for filename in args:
	set_time(filename)
