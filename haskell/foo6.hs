
import Data.IORef

data Field b = Field {
    get :: IO b,
    set :: b -> IO()    
}

makeField x = do
    field <- newIORef x
    let get = readIORef field
    let set = writeIORef field
    return (Field get set)

data Point = Point {
    x :: Field Double,
    y :: Field Double
}

makePoint x y = do
    xf <- makeField x
    yf <- makeField y
    return (Point xf yf)

main = do
    p <- makePoint 0 0
    get (x p) >>= print
    set (x p) 2
    set (y p) 3
    get (x p) >>= print

