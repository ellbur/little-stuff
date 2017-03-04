
import sys
sys.path.append('/home/owen/school/capstone/repo/')

from calculus import *
from visualization import *
from random import choice, randint

def make_tree_that_is(goal, depth):
    if depth <= 1:
        return goal
    else:
        if choice([True, False]):
            return K(make_tree_that_is(goal, depth-2))(completely_random_tree(depth-1))
        else:
            return S(make_tree_that_is(K, depth-3))(completely_random_tree(depth-1))(make_tree_that_is(goal, depth-1))

def completely_random_tree(depth):
    if depth <= 1:
        return choice([S, K])
    else:
        d = randint(0, depth-1)
        if choice([True, False]):
            return completely_random_tree(d)(completely_random_tree(depth-1))
        else:
            return completely_random_tree(depth-1)(completely_random_tree(d))

tree = make_tree_that_is(K, 12)

draw(exp_to_graph(tree, limit=''))

