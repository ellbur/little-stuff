
module BreakingNumber(
    PreNode,
    PreEdge,
    NumberedNode,
    calculateBreakingNumbers
) where

import Data.Map hiding (foldl')
import Data.List hiding (lookup)

mlookup = Data.Map.lookup

rmap = flip fmap

data PreNode = PreNode String
    deriving (Eq, Ord, Show)
    
data PreEdge = PreEdge String String
    deriving (Eq, Ord, Show)

data NumberedNode = NumberedNode String Int

nodeName (PreNode a) = a
edgeSource (PreEdge a b) = a

calculateBreakingNumebrs :: [PreNode] -> [PreEdge] -> [NumberedNode]

matchedEdges :: [(String, [String])]
matchedEdges = fst $ foldl' f ([], preEdges) preNodes where
    f (soFar, edges) node = let
            nn = nodeName node
            (thisOne, rest) = partitionWhile (\e -> edgeSource e == nn) edges
            thisOne' = thisOne `rmap` (\(PreEdge _ b) -> b)
        in
            ((nn, thisOne') : soFar, rest)

partitionWhile f [] = ([], [])
partitionWhile f (x:xs) =
    if f x
       then let
            (yes, no) = partitionWhile f xs
        in
            (x:yes, no)
       else ([], x:xs)

data AListNode = AListNode String Int [AListNode]
    deriving (Show)

aListMap :: Map String AListNode
aListMap = fromList aListPairs

aListNodes = aListPairs `rmap` (\(_, n) -> n)

aListPairs =
    matchedEdges `rmap` (\(node, adjs) ->
            let
                result = (node, AListNode node weight adjList)
                weight = computeWeight adjList
                adjList = (adjs `rmap` (\to ->
                        case mlookup to aListMap of
                             Nothing  -> undefined
                             Just aln -> aln
                    ))
            in
                result
        )

computeWeight :: [AListNode] -> Int
computeWeight ls = 1 + (sum $ ls `rmap` (\(AListNode _ w _) -> w))

