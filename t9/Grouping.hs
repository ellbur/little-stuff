
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}

module Grouping where

import Data.List (map, group, sort)

map' :: [a] -> (a -> b) -> [b]
map' = flip map

class KVPair a b c | a -> b c where
    kvKey :: a -> b
    kvValue :: a -> c
    
data KVPaired k v = KVPaired {
        kvdKey :: k,
        kvdValue :: v
    }

instance (Eq k) => Eq (KVPaired k v) where
    (KVPaired k1 _) == (KVPaired k2 _) = k1 == k2
    
instance (Ord k) => Ord (KVPaired k v) where
    (KVPaired k1 _) `compare` (KVPaired k2 _) = k1 `compare` k2

groupsOf els = res where
    pairs = map' els $ \x -> KVPaired (kvKey x) (kvValue x)
    groups = group $ sort pairs
    res = map' groups $ \group ->
        (
            kvdKey $ head group,
            map' group kvdValue
        )

