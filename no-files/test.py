
import os
import sys
from collections import namedtuple as nt

class File(nt('File', ['id', 'extention'])):
    pass
    
class Output(nt('Output', ['extention'])):
    pass
    
source = Path(...)
    
bin = run('gcc', source, '-o', Output())

solib = run('gcc', '-shared', source, '-o', Output('.so'))

class MemoKey(nt('MemoKey', ['func', 'args'])):
    pass

class ArgList(nt('ArgList'), ['positional', 'named']):
    pass

def args(*a, **b):
    return ArgList(a, b)

class Cache:
    def get(self, func, *a, **b):
        key = MemoKey(func, ArgList(a, b))
        cached = self.get_from_cache(key)
        if cached != None:
            return cached
        else:
            result = key()
            self.set_cache(key, result)
            return result
        
    def get_from_cache(self, key):
        # TODO
        return None
    
    def set_cache(self, key, result):
        # TODO
        pass
    

