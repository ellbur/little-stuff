
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RebindableSyntax #-}

import Prelude hiding (fromInteger)

fromInteger :: Integer -> Integer
fromInteger x = x

class Add a b | a -> b where
    add :: a -> b

add1 :: Integer -> Integer -> Integer
add1 x y = x + y

instance Add Integer (Integer -> Integer) where
    add = add1

add2 :: [Integer] -> Integer
add2 = sum

instance Add [Integer] Integer where
    add = add2

main = do
    print $ add [1, 2]
    print $ add 1 2

