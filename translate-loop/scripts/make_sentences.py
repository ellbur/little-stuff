#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
from optparse import OptionParser
import sys
import os
import re

sentence_pattern         = re.compile('[\\!\\.\\?]')
word_pattern             = re.compile('\\w')
leading_space_pattern    = re.compile('^\\s+')
trailing_space_pattern   = re.compile('\\s+$')
newline_pattern          = re.compile('\\n')

usage = '%prog: <source-dir>'
parser = OptionParser(usage=usage)
parser.add_option('-o', dest='output', help='output file')

options, args = parser.parse_args()
if len(args) != 1:
	parser.print_usage()
	sys.exit(1)

source_path = args[0]
output_path = options.output

sentences = [ ]

filenames = os.listdir(source_path)
for filename in filenames:
	path = source_path + '/' + filename
	
	fhandle = open(path, 'r')
	text = fhandle.read()
	fhandle.close()
	
	some_sentences = re.split(sentence_pattern, text)
	sentences.extend(some_sentences)

def clean_sentence(s):
	s = re.sub(newline_pattern, ' ', s)
	s = re.sub(leading_space_pattern, '', s)
	s = re.sub(trailing_space_pattern, '', s)
	
	return s

sentences = map(clean_sentence, sentences)

def has_word(s):
	return re.match(word_pattern, s)

sentences = filter(has_word, sentences)

output_file = sys.stdout
if output_path != None:
	output_file = open(output_path, 'w')

for s in sentences:
	print("{0}".format(s), file=output_file)

if output_path != None:
	output_file.close()
