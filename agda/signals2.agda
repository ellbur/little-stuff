
module signals2 where

-- Here we're going to try to do better the "synchronous hardware" machines we did before.

open import Level
open import Data.Product
open import Coinduction

data Bit : Set where
  b0 b1 : Bit
  
data Program : Set where
  step : (Bit → (Bit × (∞ Program))) → Program 
  
module InfiniteSim where
    open import Data.Colist
    
    simulate : Program → Colist Bit → Colist Bit
    simulate (step f) [] = []
    simulate (step f) (x ∷ xs) with f x
    ...                       | y , next-step = y ∷ (♯ simulate (♭ next-step) (♭ xs))
    
module FiniteSim where
    open import Data.List public
    open import Relation.Binary.PropositionalEquality
    
    simulate : Program → List Bit → List Bit
    simulate (step f) [] = []
    simulate (step f) (x ∷ xs) with f x
    ...                       | y , next-step = y ∷ (simulate (♭ next-step) xs)
    
    simulate-none-to-none : (p : Program) → (simulate p []) ≡ []
    simulate-none-to-none (step f) = refl
    
    none-to-simulate-none : (p : Program) → [] ≡ (simulate p [])
    none-to-simulate-none (step f) = refl
    
    length-preserving : (p : Program) → (l : List Bit) → length l ≡ length (simulate p l)
    length-preserving (step f) []  = refl
    length-preserving p (x ∷ l) = {!!}
    
allZeros : Program
allZeros = step (λ _ → b0 , (♯ allZeros))

module Example1 where
    open FiniteSim
    open import Relation.Binary.PropositionalEquality
    
    x = b0 ∷ b1 ∷ b0 ∷ []
    y = b0 ∷ b0 ∷ b0 ∷ []
    
    worked : y ≡ simulate allZeros x
    worked = refl

-- OK... now can we define signals....


