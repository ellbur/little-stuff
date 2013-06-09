
import Data.IORef

-- http://www.haskell.org/haskellwiki/OOP_vs_type_classes  
foo :: IO Int -> (Int -> IO ()) -> IO ()
foo get set = do
    set 3
    get >>= print

main = do
	x <- newIORef 2
	let get = readIORef x
	let set = writeIORef x
	foo get set


