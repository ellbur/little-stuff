
data Type = A | B | C deriving Show

a :: (Type, Int)
a = (A, 1)

b :: (Type, Int)
b = (B, 2)

c :: (Type, Int)
c = (C, 3)

-- foo takes an A and adds it to itself
-- in a typesafe manner, ie it can fail.
foo :: (Type, Int) -> Maybe (Type, Int)
foo (A, x) = Just (A, x + x)
foo (t, x) = Nothing

safeIf :: Bool -> Maybe a -> Maybe a -> Maybe a
safeIf True  (Just x) (Just y) = Just x
safeIf False (Just x) (Just y) = Just y
safeIf c Nothing y = Nothing
safeIf c x Nothing = Nothing

bar :: Bool -> (Type, Int) -> Maybe (Type, Int)
bar c v = safeIf c
	(foo v)
	(Just a)

main = do
	print (bar True a)
	print (bar True b)
	print (bar False a)
	print (bar False b)

