
module Type where

t :: a
t = t

tn :: ()
tn = t

tInt :: Int
tInt = t

tString :: String
tString = t

data TypeList a b = TypeList a b

infixr 6 ~~

(~~) :: a -> b -> TypeList a b
a ~~ b = TypeList a b

