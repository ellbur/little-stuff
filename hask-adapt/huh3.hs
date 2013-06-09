
class OK a

instance OK Int

baz :: (OK a) => a -> a
baz x = x

foo :: (OK a) => a -> a
foo x = bar x where
    bar :: a -> a
    bar x = baz x

main = do
    print $ foo (5::Int)

