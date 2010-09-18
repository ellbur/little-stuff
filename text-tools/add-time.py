#!/usr/bin/python
# -*- coding: utf-8 -*-

import time
import sys

start_time = time.time()

while 1:
	
	line = sys.stdin.readline()
	
	if len(line) == 0:
		break
	
	line = repr(time.time() - start_time) + "," + line.rstrip()
	
	print(line)
	sys.stdout.flush()
