
import random

def shuffle(s):
    s = tuple(s)
    return tuple(random.sample(s, len(s)))

def take(iter, n):
    for j in range(n):
        yield iter.next()

def group_with(s, n):
    it = iter(s)
    while True:
        t = tuple(take(it, n))
        if len(t) > 0: yield t
        else: break
    
def unpack(n, k):
    assert n >= 0
    bits = [ ]
    for _ in range(k):
        bits.append(n % 2)
        n = n >> 1
        
    bits.reverse()
    return bits

def pack(bits):
    n = 0
    p = 1
    
    bits.reverse()
    for b in bits:
        n += b*p
        p = p << 1
    return n

