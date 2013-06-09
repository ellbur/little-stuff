
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

aa :: Char -> Int
aa x = 5

bb :: Char -> Int
bb x = 7

foo :: Int -> Int -> Bool
foo x y = x == y

foo' :: (Char -> Int) -> (Char -> Int) -> (Char -> Bool)
foo' fx fy c = foo (fx c) (fy c)

class Adapt f g where
    adapt :: f -> g
    
instance Adapt (a -> b) ((c -> a) -> (c -> b)) where
    adapt = \f -> (
            \t c -> f (t c)
        )

bar :: Int -> Bool
bar x = x == 7

--bar' :: (Char -> Int) -> (Char -> Bool)
--bar' = adapt bar

main = do
    print $ foo' aa bb 'c'
    print $ ((adapt bar) bb 'c')

