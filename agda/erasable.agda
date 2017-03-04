
module erasable where

open import Data.Nat

module ListsWithNats (Magic : {!!}) where
  data ListWithNats {a : Set} : Set where
    [] : ListWithNats
    ∷  : a → {!!} → ListWithNats {a} → ListWithNats

