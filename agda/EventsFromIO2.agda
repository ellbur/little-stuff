
-- The lack of positivity annotations forces us to take such measures.
{-# OPTIONS --type-in-type #-}
{-# OPTIONS --no-positivity-check #-}
{-# OPTIONS --no-termination-check #-}

module EventsFromIO2 where

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
          
open import Data.Unit using (⊤)

module FromIO
       (Input : Set)
       (IO : Set → Set)
       (_>>=_ : ∀ {a b} → IO a → (a → IO b) → IO b)
       (return : ∀ {a} → a → IO a)
       (input : IO Input)
    where
    
  open import Coinduction
  open import Data.List using (List; _∷_; []; _++_) renaming (map to list-map)
  
  record NonemptyList (A : Set) : Set where
    constructor nonempty-list
    field
      first : A
      rest : List A
      
  _++ⁿ_ : ∀ {A} → NonemptyList A → NonemptyList A → NonemptyList A
  (nonempty-list a as) ++ⁿ (nonempty-list b bs) = nonempty-list a (a ∷ (as ++ bs))
  
  mapⁿ : ∀ {A B} → (A → B) → NonemptyList A → NonemptyList B
  mapⁿ f (nonempty-list a as) = nonempty-list (f a) (list-map f as)
  
  just-one : ∀ {A} → A → NonemptyList A
  just-one x = nonempty-list x []
  
  data MoreEvents (A : Set) : Set
  data Event (A : Set) : Set
  data DeferredEvent : (A : Set) → Set
  
  Consumer : Set → Set
  Consumer A = MoreEvents Input → Event A   
  
  data Event (A : Set) where
    have-it : (x : A) → Event A 
    waiting-on-input : DeferredEvent A → Event A 
    
  data DeferredEvent where
    raw-input : DeferredEvent (MoreEvents Input)
    computation : ∀ {A B} → DeferredEvent A → (A → B) → DeferredEvent B
    chaining : ∀ {A} → DeferredEvent (Event A) → DeferredEvent A
    ordering : ∀ {A} → DeferredEvent A → DeferredEvent A → DeferredEvent A
    
  data MoreEvents (A : Set) where
    more-events : A → Event (MoreEvents A) → MoreEvents A  
    
  id : ∀ {A} → A → A
  id x = x
  
  inputs : IO (MoreEvents Input)
  inputs = input >>= λ i → return (more-events i (waiting-on-input raw-input)) 
  
  transform-with-input : ∀ {A} → MoreEvents Input → DeferredEvent A → Event A 
  transform-with-input i raw-input = have-it i
  transform-with-input i (computation ev f) with transform-with-input i ev
  ...                                           | (have-it x) = have-it (f x)
  ...                                           | (waiting-on-input ev') = waiting-on-input (computation ev' f)
  transform-with-input i (chaining ev) with transform-with-input i ev
  ...                                      | (have-it ev') = ev'
  ...                                      | (waiting-on-input ev') = waiting-on-input (chaining ev')
  transform-with-input i (ordering ev₁ ev₂) with transform-with-input i ev₁
  ...                                           | (have-it x) = have-it x
  ...                                           | (waiting-on-input ev₁') with transform-with-input i ev₂
  ...                                                                         | (have-it y) = have-it y
  ...                                                                         | (waiting-on-input ev₂') =
                                                      waiting-on-input (ordering ev₁' ev₂')
                                                      
  get : ∀ {A} → Event A → IO A
  get (have-it x) = return x
  get (waiting-on-input fs) = inputs >>= λ i →
    get (transform-with-input i fs) 
    
  record Time : Set where
  
  Event' : (A : Time → Set) → (t : Time) → Set
  Event' A t = Event (A _)
  
  min : Time → Time → Time
  min _ _ = _
  
  instantly : ∀ {t A} (x : π A) → Event' A t 
  instantly x = have-it (x _)
  
  _map_ : ∀ {t A B} (ev : Event' A t) (f : ∀ {t} → A t → B t) → Event' B t
  _map_ (have-it x) f = have-it (f x)
  _map_ (waiting-on-input ev) f = waiting-on-input (computation ev f)
  
  chain : ∀ {A t} → Event' (Event' A) t → Event' A t
  chain {A} (have-it ev) = ev
  chain {A} (waiting-on-input ev) = waiting-on-input (chaining ev)
  
  order : ∀ {A₁ A₂ t₁ t₂} (ev₁ : Event' A₁ t₁) (ev₂ : Event' A₂ t₂)
        → Event' (λ t → (A₁ t × Event' A₂ t) ⊎ (A₂ t × Event' A₁ t)) (min t₁ t₂) 
  order {A₁′} {A₂′} ev₁ ev₂ = order' ev₁' ev₂' where
    A₁ = A₁′ _
    A₂ = A₂′ _
    
    ev₁' : Event ((A₁ × Event A₂) ⊎ (A₂ × Event A₁))
    ev₁' = ev₁ map (λ x → inj₁ (x , ev₂))
    
    ev₂' : Event ((A₁ × Event A₂) ⊎ (A₂ × Event A₁))
    ev₂' = ev₂ map (λ y → inj₂ (y , ev₁))
    
    order' : ∀ {C} → Event C → Event C → Event C 
    order' (have-it x) ev₂ = have-it x
    order' ev₁ (have-it y) = have-it y
    order' (waiting-on-input ev₁) (waiting-on-input ev₂) = waiting-on-input (ordering ev₁ ev₂)
    