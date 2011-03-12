# -*- coding: utf-8 -*-

from pyparsing import *

def Reg(*a, **b):
    return Regex(*a, **b).leaveWhitespace()

nl = Reg(r'[ \t]*\n')
small_nl = nl + NotAny(nl)
big_nl = nl + nl

word = Reg(r'[\w]+')
space = Reg(r'[ \t]+')
junk = Reg(r'[^\s\w\.\!\?]+')
gap = OneOrMore(space ^ junk ^ small_nl).leaveWhitespace()

stop = Reg(r'[\.\!\?]')

sentence = ZeroOrMore(gap.suppress()) + Group(
    ZeroOrMore(word + OneOrMore(gap.suppress()))
    + Optional(word)
)

paragraph = ZeroOrMore(stop.suppress()) + Group(
    ZeroOrMore(sentence + OneOrMore(stop.suppress()))
    + Optional(sentence)
)

page = ZeroOrMore(big_nl.suppress()) + Group(ZeroOrMore(
    paragraph + big_nl.suppress()
) + Optional(paragraph))

