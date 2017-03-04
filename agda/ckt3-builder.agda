
{-# OPTIONS --sized-types #-}

module ckt3-builder where

open import Data.String
open import Data.Product hiding (map)
open import Data.Vec hiding (_⊛_)
open import Data.Nat
open import ckt3 using (Op)
open import Size

data Proto-Expr : {i : Size} → Set where
  input_ : (name : String) → Proto-Expr
  another-wire : (name : String) → Proto-Expr
  combine : {j : Size} {n : ℕ} (op : Op n) (args : Vec (Proto-Expr {j}) n) → Proto-Expr {↑ j}
  
record Proto-Ckt {n : ℕ} {m : ℕ} : Set where
  constructor proto-ckt
  field
    input-names : Vec String n
    wires : Vec (String × Proto-Expr) m
    result : Proto-Expr
    
module Compile {num-inputs num-wires : ℕ} (proto : Proto-Ckt {num-inputs} {num-wires}) where
  open import Data.Maybe
  open import ckt3 renaming (ckt to ckt′)
  open import Find
  open import Functor-Things
  open import Equality-Things
  open import Function using (const)
  
  open Proto-Ckt proto using (input-names; wires; result)
  
  -- Compile a signal expression using the preceding wire names.
  compile-expr : {i : Size} {index : ℕ}
    (rest-of-wire-names : Vec String index) (expr : Proto-Expr {i}) → Maybe (Wire {num-inputs} {index}) 
  compile-expr _ (input name) with find input-names name
  ...                        | just index = just (input index)
  ...                        | nothing = nothing
  compile-expr rest-of-wire-names (another-wire name) with find rest-of-wire-names name
  ...                                                | just index = just (another-wire index)
  ...                                                | nothing = nothing
  compile-expr r (combine op args) = combine op <$> (sequence (compile-expr r <$> args))
  
  with-rest : ∀ {n l} {A : Set l} {B : ℕ → Set l} (start : B zero) (func : ∀ {k} → A → Vec A k → B k → B (suc k))
    (v : Vec A n) → B n
  with-rest start func [] = start
  with-rest start func (x ∷ vec) = func x vec (with-rest start func vec)
  
  EW = λ n → Maybe (Extra-Wires num-inputs n)
  compiled-wires : EW num-wires
  compiled-wires = with-rest (just no-wires) (λ wire wires′ cwires′ →
    _>add-a-wire>_ <$> cwires′ ⊛ compile-expr (map proj₁ wires′) (proj₂ wire)) wires
    
  ckt : Maybe (Ckt num-inputs {num-wires})
  ckt = ckt′ <$> compiled-wires ⊛ (compile-expr (map proj₁ wires) result)
  
open Compile public using () renaming (ckt to compile)
