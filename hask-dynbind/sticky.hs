
class OK a where
    ok :: a -> a
    
instance OK Int  where ok = id
instance OK Char where ok = id

foo x = ok x
bar x = ok x

s f g x = (f x, g x)

baz = s foo bar

main = do
    print "hi"

