
-- Yes I know this exists already. I'm just practicing Haskell.

module HList where

data HPair f a b = HPair (f a) b
    deriving (Show)

data HNil = HNil
    deriving (Show)

infixr 6 ~~
(~~) :: fa -> b -> HPair f a b
fa ~~ b = HPair fa b

