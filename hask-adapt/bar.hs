
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

infixl <*>
a <*> b = a + b

class SoftFunctor f where
    sfmap :: (a -> b) -> (f a) -> (f b)
    bcast :: a -> (f a)
    lineUp :: (f (b -> c)) -> (f b) -> (f c)

data Over t x = Over (t -> x)

instance SoftFunctor (Over t) where
    sfmap g (Over p) = Over (g . p)
    bcast c = Over (\x -> c)
    lineUp (Over g) (Over h) = Over (\t ->
        (g t) (h t) )

at :: t -> (Over t x) -> x
at t (Over f) = f t

main = do
    print $ at 'c' $ sfmap bar (Over aa)
    print $ at 'c' $ sfmap bar (Over bb)
    print $ at 'c' $ lineUp (sfmap foo (Over aa)) (Over bb)
    print $ at 'c' $ lineUp (sfmap foo (Over aa)) (Over aa)

