
class Predict f where
    predict :: (Functor u) => u (f a) -> f (u a)

instance Predict ((->) a) where
    predict x = \arg -> fmap (\y -> y arg) x

x :: [Int -> Int]
x = [\x -> x+1, \x -> x+2, \x -> x+3]

y = predict x

