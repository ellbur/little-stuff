# -*- coding: utf-8 -*-

from __future__ import print_function

class WordBlockList(list):
    
    def __init__(self,
        parser,
        keyword_matcher,
        canonicalizer,
        story_texts
    ):
        self.keyword_matcher = keyword_matcher
        self.canonicalizer   = canonicalizer
        
        for story_text in story_texts:
            self.do_story(parser, story_text)
    
    def do_story(self, parser, story_text):
        structure = parser(story_text)
        
        self.do_block(1.0, structure, [])
    
    def do_block(self, weight, structure, parents):
        if isinstance(structure, str):
            self.put(structure, parents)
        
        elif len(structure) > 0:
            block = Block(weight)
            parents = parents + [block]
            weight = weight/len(structure)
            
            for child in structure:
                self.do_block(weight, child, parents)
            
            if len(block) > 0:
                self.append(block)
    
    def put(self, word, chain):
        if not(self.keyword_matcher(word)):
            return
        
        word = self.canonicalizer(word)
        
        for block in chain:
            block.add_word(word)

class Block(dict):
    
    def __init__(self, weight):
        dict.__init__(self)
        
        self.weight = weight
    
    def add_word(self, word):
        if word in self:
            self[word] += 1
        
        else:
            self[word] = 1
    
    def __str__(self):
        return '({0}){1}'.format(self.weight, dict.__str__(self))

