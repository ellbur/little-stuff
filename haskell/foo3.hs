
import Data.IORef

-- http://www.haskell.org/haskellwiki/OOP_vs_type_classes  
foo :: IO () -> IO Int -> IO ()
foo inc get = do
	inc
	inc
	get >>= print

main = do
	x <- newIORef 2
	foo (modifyIORef x (+1)) (readIORef x)

