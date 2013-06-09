
module Trim where

open import Data.Char
open import Data.String
open import Data.List
open import Data.Bool

space : Char -> Bool
space ' '  = true
space '\n' = true
space '\t' = true
space x    = false

tailTrim' : (List Char) → (List Char)
tailTrim' [] = []
tailTrim' (car ∷ cdr) =
    if (space car) ∧ (null cdr)
        then []
        else car ∷ (tailTrim' cdr)

tailTrim : String → String
tailTrim x = fromList (tailTrim' (toList x))

trim' : (List Char) → (List Char)
trim' [] = []
trim' (car ∷ cdr) =
    if space car
       then trim' cdr
       else car ∷ (tailTrim' cdr)

trim : String → String
trim x = fromList (trim' (toList x))


