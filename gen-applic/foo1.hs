
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

import Prelude

flatten [] = []
flatten (x:xs) = x ++ (flatten xs)

class Applicative m where
    pure :: a -> m a
    ap :: m (a -> b) -> m a -> m b
    
instance Applicative [] where
    pure x = [x]
    ap mf mx = flatten $ map (\f -> map f mx) mf

main = do
    print $ (pure (+1)) `ap` [1, 2, 3]

