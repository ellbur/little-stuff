
# Now here's the story.
#
# You know how PageRank imagines a bunch of ants wandering randomly around a network,
# and weights nodes by the stationary frequency of ants at that spot. Now imagine you
# really hate ants, but you have to walk through this network from point A to point B.
#
# IE, run PageRank, create weights for the edges (which can be done basically by the
# same algorithm as weighting nodes), then run Dijkstra's with the resulting weights.

