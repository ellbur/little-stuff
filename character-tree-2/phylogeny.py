
from operator import add
import numpy as np
import memoize

def build_phylogeny(objects, relator):
    trees = [ Leaf([object]) for object in objects ]
    relator = memoize.memoized(tree_relator(relator))
    
    while 1:
        if len(trees) <= 1:
            break
        
        pinch_trees(trees, relator)
    
    return trees[0]

def pinch_trees(trees, relator):
    max_rel = -np.Inf
    max_pair = (None, None)
    
    for i in range(len(trees)-1):
        for j in range(i+1, len(trees)):
            tree1 = trees[i]
            tree2 = trees[j]
            
            rel = relator(tree1, tree2)
            
            print('{2}: {0} {1}'.format(
                tree1.objects,
                tree2.objects,
                rel
            ))
            
            if rel > max_rel:
                max_rel = rel
                max_pair = (tree1, tree2)
    
    print('Grouping {0} {1}'.format(
        max_pair[0].objects,
        max_pair[1].objects
    ))
    
    if max_pair == (None, None):
        max_pair = (trees[0], trees[1])
    
    trees.remove(max_pair[0])
    trees.remove(max_pair[1])
    
    trees.append(Branch(list(max_pair), max_rel))

def tree_relator(relator):
    def relate(tree1, tree2):
        return relator(tree1.objects, tree2.objects)
    
    return relate

class Tree:
    
    def __init__(self):
        pass
    
    def __hash__(self):
        return hash(tuple(self.objects))

class Branch(Tree):
    
    def __init__(self, children, score):
        Tree.__init__(self)
        
        self.children = children
        self.score = score
        
        self.objects = reduce(add, [
                child.objects for child in children
            ], [])
    
    def as_list(self):
        return [child.as_list() for child in self.children]

class Leaf(Tree):
    
    def __init__(self, objects):
        Tree.__init__(self)
        
        self.objects = objects
    
    def as_list(self):
        if len(self.objects) == 1:
            return self.objects[0]
        
        return self.objects

