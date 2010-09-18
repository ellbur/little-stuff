#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
import word_blocks
import phylogeny
import re
import pickle
import name_tree
import sys
from optparse import OptionParser

def main():
	
	usage = "%prog <story-dir> <names-file> <output-file>";
	parser = OptionParser(usage=usage)
	parser.add_option('--word-pattern', dest='word_pattern',
		help='perl regex to match words on')
	
	options, args = parser.parse_args()
	
	if len(args) != 3:
		print('Need 3 arguments', file=sys.stderr)
		parser.print_help()
		sys.exit(1)
	
	story_path = args[0]
	name_path  = args[1]
	dump_path  = args[2]
	
	word_pattern = options.word_pattern or '\\w+'
	
	people = read_names(name_path)
	blocks, story_blocks = word_blocks.make_blocks(story_path,
		word_pattern=word_pattern)
	all_blocks = blocks
	
	bunches = [ None ] * len(people)
	for i in range(len(people)):
		name = people[i]
		weight = sum([b.has(name) for b in story_blocks])
		
		bunches[i] = name_tree.NameBunch(all_blocks)
		bunches[i].set_leaf(name, blocks, weight)
	
	tree = phylogeny.build_tree(bunches)
	
	strip_tree(tree)
	
	dump = open(dump_path, 'w')
	pickle.dump(tree, dump)
	dump.close()

def read_words(filename):
	word_pattern = re.compile("\\w+")
	
	all_file = open(filename, 'r')
	all_text = all_file.read()
	all_file.close()
	
	word_list = word_pattern.findall(all_text)
	word_list = [ word.lower() for word in word_list ]
	
	return word_list

def read_names(filename):
	people_file = open(filename, 'r')
	people_lines = people_file.readlines()
	people_file.close()
	
	people = [ line.rstrip().lower() for line in people_lines ]
	
	return people

def strip_tree(node):
	if node.is_leaf:
		node.weight = node.element.weight
	
	node.element = None
	
	for child in node.children:
		strip_tree(child)

main()
