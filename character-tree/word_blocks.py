# -*- coding: utf-8 -*-

from __future__ import print_function
import re
import os

def make_blocks(story_path, word_pattern='\\w+'):
	blocker = Blocker(story_path, word_pattern)
	
	return blocker.blocks, blocker.story_blocks

class Blocker:
	
	def __init__(self, story_path, word_pattern):
		self.story_path       = story_path
		self.word_pattern     = re.compile(word_pattern)
		self.par_pattern      = re.compile('(\\n\\s*\\n\\s*)*')
		self.sentence_pattern = re.compile('[\.\!\?]')
		
		self.blocks       = [ ]
		self.story_blocks = [ ]
		
		filenames = os.listdir(self.story_path)
		
		for filename in filenames:
			print(filename)
			
			path = self.story_path + '/' + filename
			self.do_file(path)
	
	def do_file(self, path):
		file = open(path, 'r')
		text = file.read()
		file.close()
		
		block = self.make_block(text)
		self.blocks.append(block)
		self.story_blocks.append(block)
		
		pars = self.break_paragraphs(text)
		for par in pars:
			self.do_paragraph(par)
	
	def do_paragraph(self, text):
		self.blocks.append(self.make_block(text))
		
		sents = self.break_sentences(text)
		for sent in sents:
			self.do_sentence(sent)
	
	def do_sentence(self, text):
		self.blocks.append(self.make_block(text))
	
	def make_block(self, text):
		words = self.break_words(text)
		return Block(text, words)
	
	def break_words(self, text):
		return self.word_pattern.findall(text)
	
	def break_paragraphs(self, text):
		return re.split(self.par_pattern, text)
	
	def break_sentences(self, text):
		return re.split(self.sentence_pattern, text)

class Block:
	
	def __init__(self, text, words):
		self.table = dict( )
		self.text  = text
		
		for word in words:
			word = word.lower()
			self.table[word] = 1
	
	def has(self, word):
		if word in self.table:
			return self.table[word]
		
		return 0

