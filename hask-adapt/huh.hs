
data Func a b = Func (a -> b)

call :: Func a b -> a -> b
call (Func f) x = f x

main = do
    let bar = Func (\x -> x)
    print $ call bar (5::Int)
    print $ call bar "hi"

