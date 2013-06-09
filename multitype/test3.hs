
data Type =
	A |
	B
	deriving (Show, Eq)

a = Just (A, 1)
b = Just (B, 2)

a1 = Just (A, 1)
a2 = Just (A, 2)

safeIf :: Bool -> Maybe a -> Maybe a -> Maybe a
safeIf True  (Just x) (Just y) = Just x
safeIf False (Just x) (Just y) = Just y
safeIf c Nothing y = Nothing
safeIf c x Nothing = Nothing

add :: Maybe (Type, Int) -> Maybe (Type, Int) -> Maybe (Type, Int)
add (Just (A, x)) (Just (A, y)) = Just (A, x + y)
add x y = Nothing

get :: Bool -> (Int -> Maybe a) -> Maybe a
get True f  = f 5
get False f = Nothing

foo :: Int -> Maybe (Type, Int)
foo x = add (Just (A, x)) (Just (A, x))

main = do
	print (get True foo)
	print (get False foo)
	

