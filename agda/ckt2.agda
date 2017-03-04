
module ckt2 where

open import Data.Nat
open import Data.Fin using (Fin; #_) renaming (suc to sucFin; zero to zeroFin)
open import Data.List hiding (and; or)
open import Data.String hiding (fromList)
open import Data.Maybe
open import Data.Product
open import Data.Vec using (Vec; fromList) renaming ([] to []v; _∷_ to _∷v_)
open import Equality-Things
open import Functor-Things

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
  _>add-a-wire>_ : {n : ℕ} → CC-Design {n} → CC-Expr {n} → CC-Design {suc n}
  
infixl 6 _and'_
infixl 6 _or'_
data Proto-Expr : Set where
  _and'_ : Proto-Expr → Proto-Expr → Proto-Expr
  _or'_ : Proto-Expr → Proto-Expr → Proto-Expr
  not'_ : Proto-Expr → Proto-Expr
  input' : (input-number : ℕ) → Proto-Expr
  another-wire' : (wire-name : String) → Proto-Expr
  
find : ∀ {A} → {{_ : A-DE A}} → {n : ℕ} → Vec A n → A → Maybe (Fin n)
find []v _ = nothing
find (x′ ∷v v′) x with x′ == x ??
...              | yes _ = just (# 0)
...              | no _  = find v′ x >map> sucFin

module With-Names {n : ℕ} (names : Vec String n) where
  -- Compile a single expression
  ccpe : (expr : Proto-Expr) → Maybe (CC-Expr {n})
  ccpe (x and' y) = _and_ <$> (ccpe x) ⊛ (ccpe y)
  ccpe (x or' y) = _or_ <$> (ccpe x) ⊛ (ccpe y) 
  ccpe (not' x) = not_ <$> (ccpe x) 
  ccpe (input' n) = just (input n) 
  ccpe (another-wire' name) with find names name
  ...                      | just i = just (another-wire i)
  ...                      | nothing = nothing
  
open With-Names

module With-Statements (statements : List (String × Proto-Expr)) where
  -- Convert the list of statements to a vector of statements.
  svec = fromList statements
  
  names = svec >map> proj₁
  exprs = svec >map> proj₂
  
  compile-iter : ∀ {n′} → (exprs′ : Vec Proto-Expr n′) → (names' : Vec String n′) → Maybe (CC-Design {n′})
  compile-iter []v []v = just no-wires
  compile-iter (e ∷v es) (l ∷v ls) = _>add-a-wire>_ <$> (compile-iter es ls) ⊛ (ccpe ls e)   
  
  compile-proto-design : Maybe CC-Design 
  compile-proto-design = compile-iter exprs names  
  
open With-Statements public
