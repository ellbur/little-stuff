
module someio where

import Foreign.Haskell as Hask
open import IO.Primitive renaming (putStrLn to putStrLnCo)
open import Data.String
open import Function using (_∘_)

putStrLn = putStrLnCo ∘ toCostring

infixl 1 _>>_

postulate
    _>>_  : ∀ {a b} {A : Set a} {B : Set b} → IO A → (IO B) → IO B
    getLine : IO String

{-# COMPILED _>>_  (\_ _ _ _ -> (>>)) #-}
{-# COMPILED getLine (getLine) #-}

main : IO Hask.Unit
main =
    putStrLn "Hello, World!" >>
    putStrLn "Whatup!" >>
    getLine >>= \up ->
    putStrLn ("Your face is " ++ up)

