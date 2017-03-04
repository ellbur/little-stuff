
module co2 where

open import Coinduction

id : ∀ {l} {A : Set l} → A → A
id x = x

module doesn't-work where

  data Doll : Set where
    doll : ∞ Doll → Doll
    
  lucy : Doll
  lucy = doll (♯ {!!}) 
-- doll (♯ (id lucy))