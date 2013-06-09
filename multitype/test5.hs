
class Extractable a where
   extract :: String -> Maybe a	

extractInt :: String -> Maybe Int
extractInt "1" = Just 1
extractInt  e  = Nothing

instance Extractable Int where
	extract = extractInt

load :: (Extractable a) => String -> (a -> b) -> Maybe b
load text f = (fmap f) (extract text)

foo :: Int -> Int
foo x = x + 2

main = do
	let x = load "1"
	let y = load "2"
	print (x foo)
	print (y foo)

