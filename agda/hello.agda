
-- Compiles with Agda 2.3.0 and standard library 0.6
-- on 2012-03-13

module hello where

open import IO.Primitive
open import Data.String

import Foreign.Haskell as Hask

main : IO Hask.Unit
main = putStrLn (toCostring "Hello, World!")

