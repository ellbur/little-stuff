
-- The lack of positivity annotations forces us to take such measures.
{-# OPTIONS --type-in-type #-}
{-# OPTIONS --no-positivity-check #-}
{-# OPTIONS --no-termination-check #-}

module EventsFromIO where

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
  
  Consumer : Set → Set
  Consumer A = MoreEvents Input → Event A   
  
  data Event (A : Set) where
    have-it : (x : A) → Event A 
    waiting-on-input : NonemptyList (Consumer A) → Event A 
    
  data MoreEvents (A : Set) where
    more-events : A → Event (MoreEvents A) → MoreEvents A  
    
  id : ∀ {A} → A → A
  id x = x
  
  inputs : IO (MoreEvents Input)
  inputs = input >>= λ i → return (more-events i (waiting-on-input (just-one have-it))) 
  
  combine : ∀ {A} → Event A → Event A → Event A
  combine (have-it x) ev₂ = have-it x
  combine ev₁ (have-it x) = have-it x
  combine (waiting-on-input fs) (waiting-on-input gs) = waiting-on-input (fs ++ⁿ gs)
  
  build-up : ∀ {A} → NonemptyList (Event A) → Event A 
  build-up (nonempty-list ev []) = ev
  build-up (nonempty-list ev₁ (ev₂ ∷ evs)) = build-up (nonempty-list (combine ev₁ ev₂) evs)
  
  transform-with-input : ∀ {A} → (MoreEvents Input) → NonemptyList (Consumer A) → Event A 
  transform-with-input i fs = build-up (mapⁿ (λ f → f i) fs)
  
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
  _map_ {_} {A} {B} (waiting-on-input cs) f = waiting-on-input (just-one consumer) where
    -- This is wierd. Can this really by right? It feels so wrong.
    consumer : MoreEvents Input → Event (B _)
    consumer i = transform-with-input i cs map f
    
  chain : ∀ {A t} → Event' (Event' A) t → Event' A t
  chain {A} (have-it ev) = ev
  chain {A} (waiting-on-input cs) = {!!}
  
  order : ∀ {A₁ A₂ t₁ t₂} (ev₁ : Event' A₁ t₁) (ev₂ : Event' A₂ t₂)
        → Event' (λ t → (A₁ t × Event' A₂ t) ⊎ (A₂ t × Event' A₁ t)) (min t₁ t₂) 
  order (have-it x) ev₂ = have-it (inj₁ (x , ev₂)) 
  order ev₁ (have-it y) = have-it (inj₂ (y , ev₁))
  order {A₁′} {A₂′} (waiting-on-input fs) (waiting-on-input gs) = waiting-on-input combined where
    A₁ = A₁′ _
    A₂ = A₂′ _
    
    combined : NonemptyList (Consumer ((A₁ × Event A₂) ⊎ (A₂ × Event A₁)))
    combined = {!!}
    
    