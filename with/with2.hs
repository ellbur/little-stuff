
newtype Context a = Context (IO (a, IO()))

instance Monad Context where
    return x = Context (return (x, return()))
    (Context p1) >>= f = Context $ do
        (a, x1) <- p1
        let Context p2 = f a
        (b, x2) <- p2
        return (b, x2 >> x1)

runContext :: Context a -> IO a
runContext (Context ioA) = do
    (a, exit) <- ioA
    exit
    return a

ioToContext :: IO a -> Context a
ioToContext ioX = Context (ioX >>= \x -> return (x, return ()))

a = Context $ print "Enter A" >> return ((), print "Exit A")
b = Context $ print "Enter B" >> return ((), print "Exit B")

foo :: a -> Context ()
foo _ = b >> (ioToContext $ print "Inside")

bar :: () -> Context ()
bar () = a >>= foo

main = runContext $ bar ()

