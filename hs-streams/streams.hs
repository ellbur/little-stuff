
import Text.Printf
import Control.Comonad
import Control.Applicative

-- Before, current:after
data Stream a = Stream [a] [a]

instance (Show a) => Show (Stream a) where
    show (Stream bf (cur:af)) = msg where
        msg = printf "(... %s) %s (%s ...)" bf' cur' af'
        bf'  = show $ reverse $ take 2 bf
        cur' = show cur
        af'  = show $ take 3 af

instance Functor Stream where
    fmap f (Stream bf af) =
        Stream (fmap f bf) (fmap f af)

instance Extend Stream where
    duplicate = expandStream

instance Comonad Stream where
    extract = extractStream

extractStream :: Stream a -> a
extractStream (Stream _ (a:_)) = a

upStream :: Stream a -> Stream a
upStream (Stream br (af:afs)) =
    Stream (af:br) afs

dnStream :: Stream a -> Maybe (Stream a)
dnStream (Stream br af) =
    case br of
         []   -> Nothing
         b:bs -> Just $ Stream bs (b:af)

-- Lazy
iterateWhileJust :: (a -> Maybe a) -> a -> [a]
iterateWhileJust f a = go (Just a) where
    go (Just a) = a : (go $ f a)
    go Nothing  = []

expandStream :: Stream a -> Stream (Stream a)
expandStream s =
    Stream br' af' where
        _:br' = iterateWhileJust dnStream s
        af'   = iterate upStream s

listToStream :: [a] -> Stream a
listToStream as = Stream [] as

streamToList :: Stream a -> [a]
streamToList (Stream _ af) = af

atStart :: Stream a -> Stream a
atStart (Stream _ af) = Stream [] af

cellMap :: (Stream a -> b) -> [a] -> [b]
cellMap f = streamToList . (f <<= ) . listToStream

natStream :: Stream Integer
natStream = listToStream $ iterate (1+) 0

oneStream :: Stream Integer
oneStream = listToStream $ iterate id 1

fibStream :: Stream Integer
fibStream = atStart $
    fibStream =>> \(Stream bf _) ->
    case bf of
         []      -> 1
         [_]     -> 1
         (a:b:_) -> a + b
        
 
