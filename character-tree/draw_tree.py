#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
import pickle
import phylo_plot
import name_tree
import phylogeny
import sys
from optparse import OptionParser

usage = '%prog <input-file> <output-image>'
parser = OptionParser(usage)

options, args = parser.parse_args()

if len(args) != 2:
	print('Need 2 arguments', file=sys.stderr)
	parser.print_help()
	sys.exit(1)

dump_path  = args[0]
image_path = args[1]

dump = open(dump_path, 'r')
tree = pickle.load(dump)
dump.close()

graph = phylo_plot.graph_tree(tree)
graph.draw(image_path, prog='dot')

