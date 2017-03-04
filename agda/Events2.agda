
{-# OPTIONS --no-positivity-check #-}
{-# OPTIONS --no-termination-check #-}
{-# OPTIONS --type-in-type #-}

module Events2 where

open import Data.Sum using (_⊎_; inj₁; inj₂) 
open import Data.Product using (_×_; proj₁; proj₂; _,_)

record EventSystem : Set where
  infixl 5 _map_
  field
    Event : (result-type : Set) → Set
    
    instantly : ∀ {r} (x : r) → Event r
    
    _map_ : ∀ {r₁ r₂} (ev : Event r₁) (f : r₁ → r₂) → Event r₂   
    
    chain : ∀ {r} (ev : Event (Event r)) → Event r
    
    order : ∀ {r₁ r₂} (ev₁ : Event r₁) (ev₂ : Event r₂)
          → Event ((r₁ × Event r₂) ⊎ (r₂ × Event r₁))
          
          