
module InstanceProblems where

module Functor-Things where
  open import Category.Functor public
  open RawFunctor {{...}} public
  
  _>map>_ : ∀ {l} → {F : _ → _} → {{_ : RawFunctor _}} {A B : Set l} → F A → (A → B) → F B  
  a >map> f = f <$> a
  
module Equality-Things where
  open import Relation.Binary public
  open import Relation.Binary.PropositionalEquality public
  open import Data.Nat
  open import Data.String
  
  Decidable-Equality : (A : Set) → Set
  Decidable-Equality A = Decidable {A = A} _≡_ 
  
  DE = Decidable-Equality
  
  record A-DE (A : Set) : Set where
    constructor a-de
    field
      _==_?? : DE A
      
  open A-DE {{...}} public
  
  de-nats : A-DE ℕ
  de-nats = a-de (Data.Nat._≟_)
  
  de-strings = a-de (Data.String._≟_)
  
module find-it-1 where
  open import Data.Nat
  open import Data.List
  open import Data.String
  open import Data.Maybe
  open import Relation.Binary
  open import Relation.Nullary.Core
  open Functor-Things
  open Equality-Things
  
  data _In_ {A : Set} : A → List A → Set where
    here-it-is : (x : A) → (y : List A) → x In (x ∷ y)
    there-it-was : {x : A} → {ls : List A} → (y : A) → x In ls → x In (y ∷ ls) 
    
  find-it : {A : Set} → {{eq? : A-DE A}} → (x : A) → (ls : List A) → Maybe (x In ls)
  find-it _ [] = nothing
  find-it x (y ∷ ls′) with x == y ??
  ...                | (yes x→y) rewrite x→y = just (here-it-is y ls′)
  ...                | (no _) = find-it x ls′
                                        >map> there-it-was y
                                        
  implicitly : ∀ {l} → (A : Set l) → {{_ : A}} → A
  implicitly _ {{x}} = x
  
  --yo : A-DE ℕ
  --yo = implicitly _
  
  open import Level renaming (zero to levelZero)
  
  test-1 : 2 In (1 ∷ 2 ∷ 3 ∷ [])
  test-1 = from-just {a = levelZero} {A = 2 In (1 ∷ 2 ∷ 3 ∷ [])} (find-it {ℕ} {{implicitly (A-DE ℕ)}} 2 (1 ∷ 2 ∷ 3 ∷ []))
  --test-1 = from-just (find-it {_} {{implicitly (A-DE ℕ)}} 2 (1 ∷ 2 ∷ 3 ∷ []))
  
  --i-know-it's-there : ∀ {A} → {{_ : A-DE A}} → (x : A) → (ls : List A) → _
  --i-know-it's-there x ls = from-just (find-it x ls)
  