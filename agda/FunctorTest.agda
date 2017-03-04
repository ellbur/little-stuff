
module FunctorTest where

open import Category.Functor public
open RawFunctor {{...}} public
open import Category.Applicative
open RawApplicative {{...}} public hiding (_<$_; _<$>_)

_>map>_ : ∀ {l} → {F : _ → _} → {{_ : RawFunctor _}} {A B : Set l} → F A → (A → B) → F B  
a >map> f = f <$> a

open import Data.Maybe
open import Data.Nat

maybeApplicative : ∀ {l} → RawApplicative {l} Maybe 
maybeApplicative = record
    { pure = λ x → just x
    ; _⊛_ = λ
      { (just f) (just x) → just (f x)
      ;  _ _ → nothing
      }
    }
    
f : Maybe (ℕ → ℕ)
f = just (λ x → x + 2)

x : Maybe ℕ
x = just 3

check : Maybe ℕ
check = f ⊛ x
