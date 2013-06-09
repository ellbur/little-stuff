
data Type =
	A |
	B |
	List Type
	deriving (Show, Eq)

a = Just (A, 1)
b = Just (B, 2)

a1 = Just (A, 1)
a2 = Just (A, 2)

anil = Just (List A, [])

safeIf :: Bool -> Maybe a -> Maybe a -> Maybe a
safeIf True  (Just x) (Just y) = Just x
safeIf False (Just x) (Just y) = Just y
safeIf c Nothing y = Nothing
safeIf c x Nothing = Nothing

add :: Maybe (Type, Int) -> Maybe (Type, Int) -> Maybe (Type, Int)
add (Just (A, x)) (Just (A, y)) = Just (A, x + y)
add x y = Nothing

ssum :: Maybe (Type, [Int]) -> Maybe (Type, Int)
ssum (Just (List A, ls)) = foldr
	add
	(Just (A, 0))
	[Just (A, x) | x <- ls]
ssum e = Nothing

scons :: Maybe (Type, a) -> Maybe (Type, [a]) -> Maybe (Type, [a])
scons (Just (t1, x)) (Just (List t2, xs)) =
	if t1 == t2
	then Just (List t1, x : xs)
	else Nothing
scons e1 e2 = Nothing

main = do
	print (ssum
		(scons a1
		(scons a2
		anil)))
 
