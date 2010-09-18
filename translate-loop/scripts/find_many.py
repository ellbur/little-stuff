#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys
import re
import csv
from optparse import OptionParser
from translate_loop import *

usage = '%prog: [OPTIONS]'
parser = OptionParser(usage=usage)
parser.add_option('-f', dest='from_language',
	help='Form language, two letter code')
parser.add_option('-t', dest='to_language',
	help='To language, two letter code')
parser.add_option('-s', dest='service',
	help='Translation service (see translate-bin)')

options, args = parser.parse_args()
if len(args) != 0:
	parser.print_usage()
	sys.exit(1)

from_language = options.from_language or 'en'
to_language   = options.to_language   or 'es'
service       = options.service       or 'google'

fields = [
	'leading',
	'period',
	'from',
	'to',
	'service',
	'input' ]

writer = csv.DictWriter(sys.stdout, fields)

def trim(text):
	text = re.sub('^\\s+', '', text)
	text = re.sub('\\s+$', '', text)
	return text

while 1:
	line = sys.stdin.readline()
	if line == '':
		break
	
	line = trim(line)
	
	pattern = find_pattern(line, from_language, to_language, service)
	row = {
		'leading' : pattern.leading,
		'period'  : pattern.period,
		'from'    : pattern.from_language,
		'to'      : pattern.to_language,
		'service' : pattern.service,
		'input'   : line
	}
	
	writer.writerow(row)

