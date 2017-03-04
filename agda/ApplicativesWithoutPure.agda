
module ApplicativesWithoutPure where

open import Level

-- Here is a generalization of applicatives that does not include
-- a `pure` axiom. There are real uses for this.

record UnpureApplicative {l} (F : Set l → Set l) : Set (l ⊔ suc zero) where 
  field
    -- The basic map axiom.
    _ap\_ : ∀ {A B} (f : A → B) (x : F A) → F B 
    
    -- The combine axiom.
    _/ap\_ : ∀ {A B} (f : F (A → B)) (x : F A) → F B
    
module UnpureApplicativeTest {l} (F : _) (applicative : UnpureApplicative {l} F) where
  open import Data.List using (List; []; _∷_)
  open import Data.Sum using (_⊎_; inj₁; inj₂)
  
  open UnpureApplicative applicative
  
  -- We can derive this from the other two.
  -- Agda auto was actually able to solve this one.
  _/ap_ : ∀ {B} {A : Set l} (f : F (A → B)) (x : A) → F B
  _/ap_ f x = (λ z → z x) ap\ f
  
  -- This is how sequence now looks. 
  -- It's ugly, but it gets the job done.
  sequence : ∀ {A} → List (F A) → List A ⊎ F (List A) 
  sequence [] = inj₁ []
  sequence (x ∷ list) with sequence list
  ...                     | inj₁ plain = inj₂ ((_∷_ ap\ x) /ap plain)
  ...                     | inj₂ appy = inj₂ ((_∷_ ap\ x) /ap\ appy)
  
  F' : Set l → Set l
  F' A = A ⊎ F A
  
  infixl 5 _/ap'\_
  _/ap'\_ : ∀ {A B} (f : F' (A → B)) (x : F' A) → F' B
  inj₁ f /ap'\ inj₁ x = inj₁ (f x)
  inj₁ f /ap'\ inj₂ x = inj₂ (f ap\ x)
  inj₂ f /ap'\ inj₁ x = inj₂ (f /ap x)
  inj₂ f /ap'\ inj₂ x = inj₂ (f /ap\ x)

  pure' : ∀ {A} → A → F' A
  pure' x = inj₁ x
  
  -- This version is cosmetically prettier.
  sequence' : ∀ {A} → List (F' A) → F' (List A)
  sequence' [] = inj₁ []
  sequence' (x ∷ list) = (pure' _∷_) /ap'\ x /ap'\ (sequence' list)
