
data Type a = Type String deriving (Eq, Show) 

typeA :: Type Int
typeA = Type "A"

typeB :: Type Int
typeB = Type "B"

typeC :: Type String
typeC = Type "C"

data Func a b =
	Func (Type a) (Type b) (a -> b)

checkCall :: Func a b -> (Type a, a) -> Maybe (Type b, b)
checkCall (Func tA1 tB f) (tA2, a) =
	if tA1 == tA2
	   then Just (tB, (f a))
	   else Nothing

foo :: Func Int Int
foo = Func typeA typeA (\x -> x + 2)

main = do
	print (checkCall foo (typeA, 3))
	print (checkCall foo (typeB, 3))

