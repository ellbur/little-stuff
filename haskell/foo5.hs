
import Data.IORef

data Counter = Counter {
    get :: IO Int,
    set :: Int -> IO()    
}

makeCounter x = do
    count <- newIORef x
    let get = readIORef count
    let set = writeIORef count
    return (Counter get set)

main = do
    c <- makeCounter 0
    (get c) >>= print
    set c 5
    (get c) >>= print

