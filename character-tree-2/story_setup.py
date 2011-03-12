# -*- coding: utf-8 -*-

import story_block_parser
import more_capitalized
import keyword_set
import block
from read_stories import read_stories
import operator
import phylogeny
import relatedness
import frequency

def make_story_blocks(texts, max_words):
    text = reduce(operator.add, texts, '')
    
    caps = more_capitalized.words_usually_capitalized(text)
    caps = frequency.get_most_frequent(texts, caps, max_words)
    
    parser = (lambda text:
        story_block_parser.page.parseString(text).asList()
    )
    
    canonicalizer = keyword_set.Canonicalizer()
    keyword_matcher = keyword_set.KeywordMatcher(caps)
    
    blocks = block.WordBlockList(parser, keyword_matcher, canonicalizer, texts)
    blocks.words = caps
    
    return blocks

def build_phylogeny(blocks):
    
    def related(set1, set2):
        return relatedness.table_cor(
            relatedness.cross_table(blocks, [set1, set2])
        )
    
    return phylogeny.build_phylogeny(
        blocks.words,
        related
    )

