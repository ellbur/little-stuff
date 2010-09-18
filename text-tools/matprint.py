#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
from prettytable import PrettyTable
import csv
import sys
import re

def print_table(lines):
	reader = csv.reader(lines)
	header = None
	
	for row in reader:
		header = row
		break
	
	if header == None:
		return
	
	tab = PrettyTable(header)
	for row in reader:
		tab.add_row(row)
	
	tab.printt(border = False)

def handle_par(lines):
	if len(lines) == 0: return
	
	header = lines[0]
	if re.search('\,', header):
		print_table(lines)
		print("")
		return
	
	for line in lines:
		print(line, end="")

lines = [ ]
for line in sys.stdin:
	if re.search('^\s*$', line):
		handle_par(lines)
		lines = [ ]
	else:
		lines.append(line)

handle_par(lines)
