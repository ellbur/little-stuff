
module eta where

open import Data.Unit
open import Coinduction

data Eta : Set where
  eta : (Unit → ∞ Eta) → Eta
  
foo : Eta
foo = eta (λ _ → ♯ foo)
