
data Context a = Context [String] a [String]
    deriving (Show)

a = Context ["Enter A"] () ["Exit A"]
b = Context ["Enter B"] () ["Exit B"]

instance Monad Context where
    return x = Context [] x []
    (Context x1 p y1) >>= f =
        let
            Context x2 q y2 = f p
        in
            Context (x1 ++ x2) q (y2 ++ y1)

foo :: a -> Context String
foo _ = b >> (return "Inside")

bar :: () -> Context String
bar () = a >>= foo

main = do
    print $ bar ()

