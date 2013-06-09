
from collections import namedtuple as nt
import random
from misc import *
from math import log

# X -> Y
num_inputs  = 8
num_outputs = 10

n = num_inputs
m = num_outputs

N = 1 << n
M = 1 << m

a = 6
b = -log(2)/log(1 - 1./2**a)

def goodness(a):
    b = -log(2)/log(1 - 1./2**a)
    b = round(b)
    
    bias = 1 - (1. - 1./2**a)**b
    return abs(bias - 0.5)

# x&x | x&x
num_products = int(round(b))
num_factors  = a

bias = 1 - (1. - 1./2**num_factors)**num_products

num_spots = num_products * num_factors * num_outputs
num_each = (num_spots+num_inputs*2-1) // (num_inputs*2)

class Factor(nt('Factor', ['var', 'neg'])):
    def __repr__(self):
        return '%s%s' % (
            '-' if self.neg else '+',
            self.var
        )

x_factors = tuple(
    f
    for k in range(num_inputs)
    for f in [Factor(k, False), Factor(k, True)]
)

class Func:
    
    def __init__(self):
        terms = [
            v
            for u in x_factors
            for v in (u,) * num_each
        ]
        terms = terms[:num_spots]
        layout = shuffle(terms)

        key = tuple(group_with(layout, num_factors))
        key = tuple(group_with(key, num_products))
        
        self.terms = terms
        self.layout = layout
        self.key = key
        
    def __call__(self, num):
        bits = unpack(num, num_inputs)
        return pack(self.call_bits(bits))
    
    def call_bits(self, bits):
        return [
            self.eval_output(sum, bits)
            for sum in self.key
        ]
    
    def eval_output(self, sum, bits):
        def grab(fac):
            if fac.neg: return not bits[fac.var]
            else:       return     bits[fac.var]
            
        return any(
            all(grab(f) for f in prod)
            for prod in sum
        )
    
    def coverage(self):
        counts = [ 0 ] * M
        for k in range(N):
            counts[self(k)] += 1
            
        return sum(c>0 for c in counts) / float(N)

