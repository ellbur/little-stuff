
module InteractiveEvents {l} (IO : Set l → Set l) where

open import Level
open import Data.Sum using (_⊎_; inj₁; inj₂) 
open import Data.Product using (_×_; proj₁; proj₂; _,_)
open import Data.Maybe using (Maybe; just; nothing)

data ⊤-l : Set l where
  unit-l : ⊤-l
  
-- This is not your grandfather's observable. When you add a listener, that
-- listener is called *only once*.
record Observable (A : Set l) : Set l where
  field
    add-once-listener : (A → IO ⊤-l) → IO ⊤-l
    
record Observer (A : Set l) : Set l where
  field
    call : A → IO ⊤-l
    
-- This is understood to interact with some kind of IO monad.
record InteractiveEventSystem : Set (suc l ⊔ suc zero) where
  infixl 5 _map_
  
  field
    -- The type of a one-shot event, ie it does not repeat.
    -- It is not an event stream.
    -- IT MAY BE an event that happens "instantly".
    -- This is how we allow events to be a monad.
    -- This is how we get pure.
    Event : (result-type : Set l) → Set l
    
    -- Axioms of Events
    -- ----------------
    
    -- Basic map.
    _map_ : ∀ {r₁ r₂} (ev : Event r₁) (f : r₁ → r₂) → Event r₂   
    
    -- Wait for the second in a series of events. 
    chain : ∀ {r} (ev : Event (Event r)) → Event r
    
    -- Create an event that happens instantly.
    instantly : ∀ {r} (result : r) → Event r 
    
    -- For any two events, one of them happens first.
    order : ∀ {r₁ r₂} (ev₁ : Event r₁) (ev₂ : Event r₂)
          → Event ((r₁ × Event r₂) ⊎ (r₂ × Event r₁))
          
    -- Interaction with the Real World      
    -- -------------------------------
    
    -- Create an event from a callback.
    listen : ∀ {A} → Observable A → IO (Event A)
    
    -- Act on an event. 
    act : ∀ {A} → Event A → Observer A → IO ⊤-l
    