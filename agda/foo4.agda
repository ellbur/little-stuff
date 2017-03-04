
module foo4 where

open import Reflection

module some-tests where

    data Foo : Set where
      foo : Foo
      
    x : Name
    x = quote foo
    
    data Bar : Set where
      bar : Foo → Bar
      
    y : Term
    y = quoteTerm (bar foo)
    
    z : Type
    z = type x
    
    w : Definition
    w = definition (quote y)
    
    yo : Bar
    yo = bar foo
    
    t : Term
    t = quoteTerm yo
    
data Bit : Set where
  b0 b1 : Bit
  
id : {A : Set} → A → A
id x = x

module fpga-design (wire-a : Bit) where

  _and_ : Bit → Bit → Bit
  _and_ b0 b0 = b0
  _and_ b0 b1 = b0
  _and_ b1 b0 = b0
  _and_ b1 b1 = b1
  
  not : Bit → Bit
  not b0 = b1
  not b1 = b0
  
  result : Bit
  result = wire-a and (not wire-a)
  
  code : Term
  code = quoteTerm result
  
module fpga-design-2 where
  open import Data.Nat
  
  -- Combinational circuit.
  -- Simple enough basic set of operations.
  data CC : Set where
    _and_ : CC → CC → CC
    _or_ : CC → CC → CC
    not_ : CC → CC
    input : ℕ → CC
    
  x = input 0
  y = input 1
  z = x and y
  w = x or (not z)
  
  t = w or w
  
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
  open import Data.Bool
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
                                        
  test-1 : _ In _
  test-1 = from-just (find-it {ℕ} 2 (1 ∷ 2 ∷ 3 ∷ []))
  
  i-know-it's-there : ∀ {A} → {{_ : A-DE A}} → (x : A) → (ls : List A) → _
  i-know-it's-there x ls = from-just (find-it x ls)
  
module find-it-2 where
  open import Data.String
  open import Data.Nat
  open import Data.List
  open Equality-Things
  open import Data.Product
  
  x : List (String × ℕ) 
  x = ("one" , 1) ∷ ("two" , 2) ∷ ("three" , 3) ∷ [] 
  
module fpga-design-3 where
  open import Data.Nat
  open import Data.Fin using (Fin; #_)
  open import Data.List hiding (and)
  open import Data.String
  open import Data.Maybe
  open import Data.Product
  open import Data.Vec using (Vec) renaming ([] to []v; _∷_ to _∷v_)
  open Equality-Things
  
  infixl 6 _and_
  infixl 6 _or_
  data CC-Expr : {index-of-wire : ℕ} → Set where
    _and_ : ∀ {n} → CC-Expr {n} → CC-Expr {n} → CC-Expr {n}
    _or_ : ∀ {n} → CC-Expr {n} → CC-Expr {n} → CC-Expr {n}
    not_ : ∀ {n} → CC-Expr {n} → CC-Expr {n}
    input : ∀ {n} → (input-number : ℕ) → CC-Expr {n}
    another-wire : ∀ {n} → (wire-number : Fin n) → CC-Expr {n}
    
  infixl 3 _>add-a-wire>_
  data CC-Design : {number-of-wires : ℕ} → Set where
    no-wires : CC-Design {0}
    _>add-a-wire>_ : {n : ℕ} → CC-Design {n} → CC-Expr {n} → CC-Design {n + 1}
    
  my-design-1 : CC-Design
  my-design-1 = no-wires
    >add-a-wire> input 3
    
  my-design-2 = no-wires
    >add-a-wire> input 14
    >add-a-wire> input 11
    >add-a-wire> not (another-wire (# 0)) and (another-wire (# 1))
    
  infixl 6 _and'_
  infixl 6 _or'_
  data Proto-Expr : Set where
    _and'_ : Proto-Expr → Proto-Expr → Proto-Expr
    _or'_ : Proto-Expr → Proto-Expr → Proto-Expr
    not'_ : Proto-Expr → Proto-Expr
    input' : (input-number : ℕ) → Proto-Expr
    another-wire' : (wire-name : String) → Proto-Expr
    
  my-proto-design-3 : List (String × Proto-Expr)
  my-proto-design-3 = [] ∷ʳ
    ("x" ,′ (input' 14)) ∷ʳ
    ("y" ,′ (input' 11)) ∷ʳ
    ("z" ,′ (another-wire' "x" and' another-wire' "y"))
    
  Some-CC-Design = ∃ (λ n → CC-Design {n})
  
  find : ∀ {A} → {{_ : A-DE A}} → {n : ℕ} → Vec A n → A → Maybe (Fin n)
  find []v x = nothing
  find (y ∷v v) x = {!!} 
  
  compile-proto-design' : {!!} → Maybe Some-CC-Design
  compile-proto-design' = {!!}
  
  compile-proto-design : List (String × Proto-Expr) → Maybe Some-CC-Design 
  compile-proto-design [] = just (_ , no-wires)
  compile-proto-design ((name , proto-expr) ∷ rest) = {!!}
