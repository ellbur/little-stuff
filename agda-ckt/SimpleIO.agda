
module SimpleIO where

open import IO.Primitive public renaming (putStrLn to putStrLnCo)
open import Data.String public
open import Function public using (_∘_)

putStrLn = putStrLnCo ∘ toCostring

import Foreign.Haskell as Hask

Main : Set
Main = IO Hask.Unit

