
class Accept a where
	accept :: a

data A = A deriving Show
instance Accept A where
	accept = A 

data B = B deriving Show 
instance Accept B where
	accept = B

foo :: (Accept a) => a -> Int
foo a = 5

bar :: A -> Int
bar a = 5

main = do
	print (bar accept)


