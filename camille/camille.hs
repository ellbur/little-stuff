
import Control.Monad
import Data.List
import Data.Map

rmap = flip map
rfilter = flip filter

-- Names are ordered alphabetically within pairings.
-- Years are pretty approximate.

-- Person, Person Year
data Root = Root String String Double
    deriving (Show, Eq)

-- __ was introduced by __ to __ in year __
data Intro = Intro String String String Double
    deriving (Show, Eq)
    
barr2Suite = ["Michael", "John", "Jordan", "Nitish"]
suite = ["Owen", "Michael", "John", "Jordan", "Nitish", "Cody"]
barr1 = ["Vaishali", "Natalie", "Jill", "Jumana"]

except = flip delete

pairs [] = []
pairs (x : xs) = (xs `rmap` (\y -> (x, y))) ++ (pairs xs)

roots :: [Root]
roots = join [
        r "Alex"     "Katrina"  2007.0,
        r "Alex"     "Owen"     2010.2,
        r "Alex"     "Michael"  2010.2,
        r "Alex"     "Natalie"  2010.2,
        r "Anna"     "Vaishali" 2007.0,
        r "Camille"  "Natalie"  2004.7,
        r "Camille"  "Nitish"   2004.8,
        r "Cody"     "John"     2009.2,
        r "Cody"     "Owen"     2008.9,
        r "Colin"    "Owen"     2006.7,
        r "Colin"    "Kathleen" 2006.7,
        r "Dustin"   "John"     2009.9,
        r "Jeff"     "AiMei"    2011.9,
        r "Natalie"  "AiMei"    2011.9,
        r "Jeff"     "Owen"     2004.7,
        r "Jen"      "Nitish"   2008.8,
        r "Kathleen" "Natalie"  2003.0,
        r "Natalie"  "Jumana"   2008.8,
        r "Natalie"  "Nikhita"  2007.7,
        r "Natalie"  "Rishav"   2003.5,
        r "Natalie"  "Siva"     2007.7,
        r "Natalie"  "Vaishali" 2009.8,
        r "Nikhita"  "Jumana"   2008.8,
        r "Nikhita"  "Rajiv"    2003.0,
        r "Rishav"   "Siva"     2003.5,
        r "Vaishali" "Anna"     2006.7,
        r "Vaishali" "Grace"    2009.2,
        r "Nikhita"  "Grace"    2009.2,
        r "Owen"     "Michael"  2009.3,
        ["Natalie", "Jumana", "Vaishali"] >>= (\p ->
            r p "DSP" 2009.9),
        pairs barr2Suite >>= (\(a, b) ->
            r a b 2008.8),
        pairs barr1 >>= (\(a, b) ->
            r a b 2009.75)
    ]
    where
        r a b c  = [Root x y c] where
            [x, y] = sort [a, b]

introductions = join [
        i "Natalie"  "Camille"  "Nitish"    2004.9,
        i "Nitish"   "Michael"  "Owen"      2009.3,
        i "John"     "Michael"  "Owen"      2009.3,
        i "Jordan"   "Michael"  "Owen"      2009.4,
        suite `except` "Nitish" >>= (\p -> i "Natalie" "Nitish" p 2009.8),
        suite >>= (\p -> i p "Natalie" "Nikhita" 2009.9),
        suite >>= (\p -> i p "Natalie" "Siva"   2010.3),
        i "Jen"      "Nitish"   "Owen"      2009.8,
        i "Jen"      "Nitish"   "Cody"      2009.8,
        i "Jen"      "Nitish"   "Natalie"   2009.8,
        i "John"     "Natalie"  "Jumana"    2010.1,
        i "Jeff"     "Owen"     "Natalie"   2009.8,
        suite `except` "Owen" >>= (\p -> i p "Owen" "Jeff" 2009.8),
        i "Owen"     "Natalie"  "Vaishali"  2010.1,
        i "Jen"      "Nitish"   "Natalie"   2009.8,
        i "Jeff"     "Natalie"  "Nikhita"   2009.9,
        i "Jeff"     "Nitish"   "Natalie"   2009.8,
        suite `except` "John" `except` "Cody" `except` "Owen" >>= (\p ->
            i p "John" "Cody" 2009.8),
        suite `except` "John" >>= (\p -> i p "John" "Dustin" 2010.3),
        i "Nikhita"  "John"     "Dustin"    2011.3,
        i "Owen"     "Vaishali" "Anna"      2010.4,
        i "Anna"     "Owen"     "Michael"   2011.5,
        i "Jeff"     "Natalie"  "Camille"   2010.0,
        i "Natalie"  "Alex"     "Katrina"   2010.6,
        i "Owen"     "Alex"     "Katrina"   2011.5,
        i "Alex"     "Michael"  "Nikhita"   2010.4,
        i "Owen"     "Natalie"  "AiMei"     2012.3,
        i "Jeff"     "Natalie"  "Rishav"    2011.0,
        i "Vaishali" "Natalie"  "Nikhita"   2009.9,
        i "Owen"     "Siva"     "Rishav"    2011.2,
        i "Owen"     "Natalie"  "Kathleen"  2011.5,
        i "Owen"     "Natalie"  "Camille"   2011.0,
        i "Owen"     "Nikhita"  "Grace"     2010.3,
        i "Natalie"  "Nikhita"  "Grace"     2010.3,
        i "Jeff"     "Nikhita"  "Grace"     2010.3,
        i "Vaishali" "Nikhita"  "Rajiv"     2010.2,
        i "Vaishali" "Jumana"   "DSP"       2012.4
    ]
    where
        i a b c d = [Intro x b y d] where
            [x, y] = sort [a, c]

data Pairing = Pairing String String Double
    deriving (Show, Eq)

pairings = rootPairings ++ introPairings where
    rootPairings = roots `rmap` (\(Root a b year) -> Pairing a b year)
    introPairings = introductions `rmap` (\(Intro a via b year) ->
            Pairing a b year
        )

data Node a = Node String String a
    deriving (Show, Eq)

data Edge = Edge String String
    deriving (Show, Eq)

nodes = pairings `rmap` (\(p@(Pairing a b when)) ->
        Node (a ++ b) (a ++ " - " ++ b) p
    )

edges = introductions >>= (\(Intro a via b year) ->
        let
            edge1 = Edge key1 key3
            edge2 = Edge key2 key3
            key1 = keyForPair x y where [x, y] = sort [a, via]
            key2 = keyForPair x y where [x, y] = sort [b, via]
            key3 = keyForPair x y where [x, y] = sort [a, b]
        in
            [edge1, edge2]
    )

keyForPair a b = a ++ b
keyFor (Pairing a b year) = keyForPair a b
labelFor (Pairing a b year) = a ++ " - " ++ b

output = 
    "digraph family {\n" ++
    "\trankdir=\"LR\";\n"++
    join (
        pairings `rmap` (\p -> "\t" ++ keyFor p ++
            " [label=\"" ++ labelFor p ++ "\",shape=\"none\"];\n")
    ) ++
    "\t\n" ++
    join (
        introductions `rmap` (\(Intro a via b year) ->
                let
                    linkLines = edge1 ++ edge2 ++ "\n"
                    edge1 = "\t" ++ key1 ++ " -> " ++ key3 ++ "\n"
                    edge2 = "\t" ++ key2 ++ " -> " ++ key3 ++ "\n"
                    key1 = keyForPair x y where
                        [x, y] = sort [a, via]
                    key2 = keyForPair x y where
                        [x, y] = sort [b, via]
                    key3 = keyForPair x y where
                        [x, y] = sort [a, b]
                in
                    linkLines
            )
    ) ++
    "}\n"

main =
    putStrLn output

