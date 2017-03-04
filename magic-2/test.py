
from collections import namedtuple as nt

app_counter = 0

class ExtractedVersion(nt('ExtractedVersion', ['next_node', 'assumptions'])):
    pass

class Assumption(nt('Assumption', ['inner', 'outer'])):
    def compatible_with(self, pure_stack):
        for idiom in pure_stack:
            if idiom == self.inner:
                return True
            elif idiom == self.outer:
                return False
        return False

class Node:
    def __init__(self):
        self.extracted_versions = [ ]
    
    def __call__(self, x):
        return App(self, x)
    
    
        
    def __lt__(self, c):
        return isinstance(self, c)

class App(nt('App', ['car', 'cdr']), Node):
    def __init__(self, car, cdr):
        Node.__init__(self)
        global app_counter
        self.number = app_counter
        app_counter += 1
    
    def __repr__(self):
        return '[%d]%s(%s)' % (self.number, self.car, self.cdr)

class Pure(nt('Pure', ['idiom', 'child'])):
    pass

class AntiPure(nt('AntiPure', ['idiom'])):
    pass

class Leaf(nt('Leaf', ['name']), Node):
    def __repr__(self):
        return self.name

class Idiom(nt('Idiom', ['name', 'kind'])):
    def __repr__(self):
        return self.name

class IdiomKind(nt('IdiomKind', ['pure', 'ap', 'bind'])):
    pass

S = Leaf('S')
K = Leaf('K')
I = Leaf('I')
A = Leaf('A')
P = Leaf('P')

lam = IdiomKind(K, S)
foo = IdiomKind(A, P)

