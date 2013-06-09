
import Data.Set

data IdiomKind = IdiomKind {
        ik_pure :: Tree,
        ik_ap :: Tree,
        ik_bind :: Tree
    }
    deriving (Ord, Eq, Show)

data Idiom = Idiom { i_kind :: IdiomKind, i_name :: String }
    deriving (Ord, Eq, Show)

data Tree = M | S | K | I | Pure Idiom | AntiPure Idiom | App Tree Tree
    deriving (Ord, Eq, Show)

eval :: Tree -> [Idiom] -> (Tree, Set Idiom)
eval tree idioms = eval' tree where
    eval' (App (App M car) cdr) = result where
        evalCar = eval car carIdiomStack
        evalCdr = eval cdr cdrIdiomStack
        carIdiomStack = undefined
        cdrIdiomStack = undefined
        result = undefined
    eval' (App I a) = eval' a
    eval' (App (App K a) b) = eval' a
    eval' (App (App (App S a) b) c) = eval' (App (App a c) (App b c))
    eval' others = (others, empty)



