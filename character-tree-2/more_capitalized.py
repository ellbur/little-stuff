# -*- coding: utf-8 -*-

from pyparsing import *

def words_usually_capitalized(text):
    words = page.parseString(text).asList()
    table = { }
    
    for word in words:
        lcword = word.lower()
        score  = 2*word[0].isupper() - 1
        
        if not(lcword in table):
            table[lcword] = score
        else:
            table[lcword] += score
    
    cap_list = [ ]
    
    for lcword in table:
        if table[lcword] >= 2:
            cap_list.append(lcword)
    
    return cap_list

# ----------------------------------------------------------------

def Reg(*a, **b):
    return Regex(*a, **b).leaveWhitespace()

word = Reg(r'[\w]+')
gap = Reg(r'[^\w\.\!\?\:]+')

stop = Reg(r'[\.\!\?\:]')

sentence = (
      ZeroOrMore(gap).suppress()
    + Optional(word + Optional(gap)).suppress() # ignore first word of sentence
    + ZeroOrMore(word + Optional(gap.suppress()))
)

page = (
      ZeroOrMore(stop).suppress()
    + ZeroOrMore(sentence + OneOrMore(stop).suppress())
    + Optional(sentence)
)

