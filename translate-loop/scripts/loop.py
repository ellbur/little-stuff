#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys
from optparse import OptionParser
from translate_loop import *

usage = '%prog: [OPTIONS] <sentence>'
parser = OptionParser(usage=usage)
parser.add_option('-f', dest='from_language',
	help='Form language, two letter code')
parser.add_option('-t', dest='to_language',
	help='To language, two letter code')
parser.add_option('-s', dest='service',
	help='Translation service (see translate-bin)')

options, args = parser.parse_args()
if len(args) != 1:
	parser.print_usage()
	sys.exit(1)

sentence = args[0]

from_language = options.from_language or 'en'
to_language   = options.to_language   or 'es'
service       = options.service       or 'google'

pattern = find_pattern(sentence, from_language, to_language, service)
print_pattern(pattern)

