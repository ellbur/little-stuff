#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import csv
from optparse import OptionParser

usage = '%prog [OPTIONS] [FILE] ...'
parser = OptionParser(usage=usage)

options, args = parser.parse_args()

input_filenames = args
all_rows = [ ]

fields = None

for filename in input_filenames:
	handle = open(filename, 'r')
	reader = csv.DictReader(handle)
	
	if fields == None:
		fields = reader.fieldnames
	
	for row in reader:
		all_rows.append(row)
	
	handle.close()

if len(input_filenames) == 0:
	reader = csv.DictReader(sys.stdin)
	
	if fields == None:
		fields = reader.fieldnames
	
	for row in reader:
		all_rows.append(row)

if len(all_rows) == 0:
	sys.exit(0)

for row in all_rows:
	for key, value in row.items():
		
		if not (key in fields):
			fields.append(key)

header = dict()
for field in fields:
	header[field] = field

writer = csv.DictWriter(sys.stdout, fields)
writer.writerow(header)

for row in all_rows:
	writer.writerow(row)
