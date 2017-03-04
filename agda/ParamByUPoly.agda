
module ParamByUPoly where

open import Level

data OK {l} (A : Set l) : Set l where
  ok : A → OK A
  
f : ∀ {l} (A : Set l) → Set l
f A = OK A
