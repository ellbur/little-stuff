
module Functor-Things where

open import Category.Functor public
open RawFunctor {{...}} public
open import Category.Applicative
open RawApplicative {{...}} public hiding (_<$_; _<$>_)

_>map>_ : ∀ {l} → {F : _ → _} → {{_ : RawFunctor _}} {A B : Set l} → F A → (A → B) → F B  
a >map> f = f <$> a

open import Data.Maybe

maybeApplicative : ∀ {l} → RawApplicative {l} Maybe 
maybeApplicative = record
    { pure = λ x → just x
    ; _⊛_ = λ
      { (just f) (just x) → just (f x)
      ;  _ _ → nothing
      }
    }
    
open import Data.Vec hiding (_⊛_) renaming (map to mapVec)

vecFunctor : ∀ {l} → ∀ {n} → RawFunctor {l} (λ A → Vec A n) 
vecFunctor = record
  { _<$>_ = mapVec
  }
  
sequence : ∀ {l n} {F : Set l → Set l} {A : Set l} {{_ : RawApplicative F}} (v : Vec (F A) n) → F (Vec A n) 
sequence [] = pure []
sequence (x ∷ v) = (pure _∷_) ⊛ x ⊛ (sequence v)
