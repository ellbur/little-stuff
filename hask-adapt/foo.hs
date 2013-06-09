
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

aa :: Char -> Int
aa x = 5

bb :: Char -> Int
bb x = 7

foo :: Int -> Int -> Bool
foo x y = x == y

bar :: Int -> Bool
bar x = x == 7

class Apply f a b | f a -> b where
    apply :: f -> a -> b

infixl <*>
a <*> b = apply a b

instance Apply (a -> b) a b where
    apply f a = f a

data Over t x = Over (t -> x)

instance Apply (a -> b) (Over t a) (Over t b) where
    apply f (Over p) = Over (f . p)

instance Apply (Over a b) a b where
    apply (Over f) a = f a

instance Apply (Over a (b -> c)) (Over a b) (Over a c) where
    apply (Over f) (Over g) = Over (\a -> (f a) (g a))

main = do
    print $ bar <*> (5::Int)
    print $ bar <*> (Over aa) <*> 'c'
    print $ bar <*> (Over bb) <*> 'c'
    print $ foo <*> (Over aa) <*> (Over aa) <*> 'c'
    print $ foo <*> (Over aa) <*> (Over bb) <*> 'c'


