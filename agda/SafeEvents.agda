
-- The lack of positivity annotations forces us to take such measures.
{-# OPTIONS --type-in-type #-}
{-# OPTIONS --no-positivity-check #-}
{-# OPTIONS --no-termination-check #-}

module SafeEvents where

open import Data.Sum using (_⊎_; inj₁; inj₂)
open import Data.Product using (_×_; _,_)

π : {T : Set} → (T → Set) → Set
π {T} A = (t : T) → A t

record EventSystem : Set where
  field
    -- Time is probably not going to be represented by a double or int. It's not a "time" so
    -- much as a handle for getting at events.
    Time : Set
    
    -- We don't really care what this means.
    min : Time → Time → Time
    
    Event : (A : Time → Set) → (t : Time) → Set 
    
    -- An event that happens without delay.
    instantly : ∀ {t A} (x : π A) → Event A t 
    
    -- This is like usual map, but be careful, you also get a time.
    _map_ : ∀ {t A B} (ev : Event A t) (f : ∀ {t} → A t → B t) → Event B t
    
    -- This represents waiting for the second of two events.
    chain : ∀ {A t} → Event (Event A) t → Event A t
    
    -- Total ordering: for any two events, one happens first, and the other second.
    order : ∀ {A₁ A₂ t₁ t₂} (ev₁ : Event A₁ t₁) (ev₂ : Event A₂ t₂)
          → Event (λ t → (A₁ t × Event A₂ t) ⊎ (A₂ t × Event A₁ t)) (min t₁ t₂) 
          
module EventStreams (system : EventSystem) where
  open EventSystem system
  open import Data.Unit using (⊤)
  
  c-⊤ : ∀ {A} → A → Set
  c-⊤ = λ _ → ⊤
  
  second : ∀ {r t₁ t₂} → Event r t₁ → Event r t₂ → Event r (min t₁ t₂)
  second ev₁ ev₂ = chain (order ev₁ ev₂ map λ {
         (inj₁ (r , next)) → next;
         (inj₂ (r , next)) → next
    })
    
  data EventStream (A : Time → Set) (t : Time) : Set where
    empty : EventStream A t
    more-coming : Event (λ t′ → A t′ × EventStream A t′) t → EventStream A t
    
