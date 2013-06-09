
foo :: (Num a) => a -> a
foo x = x + x

main = do
	print (foo (read "7"))


