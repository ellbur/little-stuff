
module js1 where

first : {a : Set} {b : Set} -> a -> b -> a
first x y = x

open import Data.String

longComputation = "No"
result = first "Hello" longComputation

