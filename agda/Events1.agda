
-- https://lists.chalmers.se/pipermail/agda/2010/002484.html
-- https://lists.chalmers.se/pipermail/agda/2010/002485.html
{-# OPTIONS --no-positivity-check #-}
{-# OPTIONS --no-termination-check #-}
{-# OPTIONS --type-in-type #-}

-- Compiled against standard library 0.6
module Events1 where

open import Data.Sum using (_⊎_; inj₁; inj₂) 
open import Data.Product using (_×_; proj₁; proj₂; _,_)

record EventSystem : Set where
  infixl 5 _map_
  field
    -- The type of a one-shot event, ie it does not repeat.
    Event : (result-type : Set) → Set
    
    -- Axioms of Events
    
    -- Basic map.
    _map_ : ∀ {r₁ r₂} (ev : Event r₁) (f : r₁ → r₂) → Event r₂   
    
    -- Wait for the latter of one or two events. 
    chain : ∀ {r} (ev : Event (r ⊎ Event r)) → Event r
    
    -- For any two events, one of them happens first.
    order : ∀ {r₁ r₂} (ev₁ : Event r₁) (ev₂ : Event r₂)
          → Event ((r₁ × Event r₂) ⊎ (r₂ × Event r₁))
          
          