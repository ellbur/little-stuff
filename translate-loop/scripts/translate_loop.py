# -*- coding: utf-8 -*-

from __future__ import print_function
import re
import sys
import subprocess

program       = 'translate-bin'
program_path  = '/usr/bin/' + program

tags_pattern  = re.compile('\\<[^\\>]*\\>')

max_cycle = 20

def translate(text, from_language, to_language, service):
	
	args = [ program,
		'-s', service,
		'-f', from_language,
		'-t', to_language]
	
	proc = subprocess.Popen(
		executable = program,
		args = args,
		stdin  = subprocess.PIPE,
		stdout = subprocess.PIPE,
		stderr = subprocess.PIPE )
	
	out, err = proc.communicate(text)
	out = re.sub(tags_pattern, '', out)
	out = re.sub('^\\s+', '', out)
	out = re.sub('\\s+$', '', out)
	
	return out

def cycle(text, fromlang, tolang, service):
	return translate(translate(text, fromlang, tolang, service),
		tolang, fromlang, service)

class Pattern:
	
	def __init__(self, leading, period,
			from_language, to_language, samples, service):
		self.leading        = leading
		self.period         = period
		self.from_language  = from_language
		self.to_language    = to_language
		self.service        = service
		self.samples        = samples

def find_pattern(start, from_language, to_language, service):
	episodes = [ start ]
	seen = dict({ start:0 })
	
	text = cycle(start, from_language, to_language, service)
	finished = 0
	
	for i in range(max_cycle):
		if text in seen:
			finished = 1
			break
		
		seen[text] = len(episodes)
		episodes.append(text)
		
		text = cycle(text, from_language, to_language, service)
	
	if not finished:
		return Pattern('big', 'big', from_language, to_language,
			episodes, service)
	
	ab = len(episodes)
	a  = seen[text]
	b  = ab - a
	
	episodes.append(text)
	
	return Pattern(a, b, from_language, to_language, episodes, service)

def print_pattern(pattern):
	print("{0} <--> {1}".format(
		pattern.from_language,
		pattern.to_language))
	print("{0} after {1}".format(
		pattern.period,
		pattern.leading,
		pattern.samples))
	
	for i in range(len(pattern.samples)):
		line = pattern.samples[i]
		
		annotate = ''
		if i == pattern.leading or i == len(pattern.samples)-1:
			annotate = '*'
		
		print("  {0} {1}".format(line, annotate))

