
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}

data TyT = TyT
data TyF = TyF

class TyOr a b c | a b -> c

instance TyOr TyF TyF TyF
instance TyOr TyF TyT TyT
instance TyOr TyT TyF TyT
instance TyOr TyT TyT TyT

data Marked p a = Marked a
    deriving (Show)

(>>%) :: (TyOr p q r) => Marked p a -> (a -> Marked q b) -> Marked r b
(Marked x) >>% f = Marked y where Marked y = f x

a :: Marked TyF Int
a = Marked 5

f :: Int -> Marked TyT Int
f x = Marked (x + 1)

