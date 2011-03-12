# -*- coding: utf-8 -*-

import numpy as np

def block_has(block, word_set):
    return any(word in block for word in word_set)

def cross_table(blocks, word_sets):
    table = np.zeros([2] * len(word_sets))
    
    for block in blocks:
        key = tuple([
            block_has(block, word_set)
            for
                word_set in word_sets
        ])
        
        count = table.__getitem__(key)
        count += block.weight
        
        table.__setitem__(key, count)
    
    return table

def table_cor(table):
    total = np.sum(table)
    
    pAB = table[1,1] / total
    pA  = (table[1,0] + table[1,1]) / total
    pB  = (table[0,1] + table[1,1]) / total
    
    res =  pAB / pA / pB
    if np.isnan(res):
        return 0.0
    return res

