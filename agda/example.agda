
module example where

open import Data.Nat
open import Data.String

yo : ℕ → String
yo zero = "Hello"
yo _ = "No!!"

Yo-Type : ℕ → Set
Yo-Type zero = String
Yo-Type (suc _) = ℕ

yo₂ : (n : ℕ) → Yo-Type n
yo₂ zero = "Hello"
yo₂ (suc _) = 5

------------------------------------------------

open import Data.Bool

data More-True : (x : Bool) → (y : Bool) → Set where
  rule : More-True true false
