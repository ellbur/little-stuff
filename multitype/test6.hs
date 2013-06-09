
import Maybe

maybeRead :: (Read a) => String -> Maybe a
maybeRead = fmap fst . listToMaybe . reads

load :: (Read a) => String -> (a -> b) -> Maybe b
load text f = (fmap f) (maybeRead text)

foo :: Int -> Int
foo x = x + 2

main = do
	let x = load "1"
	let y = load "a"
	print (x foo)
	print (y foo)

