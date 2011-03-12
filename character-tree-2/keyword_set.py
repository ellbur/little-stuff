# -*- coding: utf-8 -*-

class KeywordMatcher:
    
    def __init__(self, word_list):
        self.table = { }
        self.words = word_list
        
        for word in word_list:
            self.table[word] = 1
    
    def __call__(self, word):
        return word.lower() in self.table

class Canonicalizer:
    
    def __init__(self):
        pass
    
    def __call__(self, word):
        return word.lower()

