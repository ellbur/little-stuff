
module quotients1 where

open import Data.Product hiding (map)
open import Data.Nat
open import Data.Nat.Properties
open import Relation.Binary.PropositionalEquality
open ≡-Reasoning
open import Algebra.FunctionProperties
open import Algebra.Structures
open import Function using (_$_)
open import Data.List

pairSum : ℕ × ℕ → ℕ
pairSum (a , b) = a + b

open IsCommutativeSemiring isCommutativeSemiring using (+-isCommutativeMonoid)
open IsCommutativeMonoid +-isCommutativeMonoid using () renaming (comm to +-comm)

pairSumSymmetry : (a b : ℕ) → pairSum (a , b) ≡ pairSum (b , a)
pairSumSymmetry a b rewrite +-comm a b = refl

infixr 4 _²→_
record _²→_ (A B : Set) : Set where
  constructor ⟦_⟧
  field
    func : A × A → B
    {pf} : (a b : A) → func (a , b) ≡ func (b , a)
    
pairSum′ : ℕ ²→ ℕ
pairSum′ = ⟦ pairSum ⟧ {pairSumSymmetry}

mapSym : ∀ {A B} (f : A ²→ B) (ls : List (A × A)) → List B
mapSym ⟦ f ⟧ ls = map f ls

data _~_ {A : Set} (x : A × A) : A × A → Set₁ where
  refl₁ : x ~ x
  refl₂ : x ~ swap x
  
data Either {l} (A B : Set l) : Set l where
  left : A → Either A B
  right : B → Either A B
  
x₁-equals : {A : Set} {x₁ y₁ x₂ y₂ : A} (pf : (x₁ , y₁) ~ (x₂ , y₂)) → Either (x₁ ≡ x₂) (x₁ ≡ y₂) 
x₁-equals refl₁ = left refl
x₁-equals refl₂ = right refl

y₁-equals : {A : Set} {x₁ y₁ x₂ y₂ : A} (pf : (x₁ , y₁) ~ (x₂ , y₂)) → Either (y₁ ≡ x₂) (y₁ ≡ y₂) 
y₁-equals refl₁ = right refl
y₁-equals refl₂ = left refl

x₂-equals : {A : Set} {x₁ y₁ x₂ y₂ : A} (pf : (x₁ , y₁) ~ (x₂ , y₂)) → Either (x₁ ≡ x₂) (y₁ ≡ x₂) 
x₂-equals refl₁ = left refl
x₂-equals refl₂ = right refl

y₂-equals : {A : Set} {x₁ y₁ x₂ y₂ : A} (pf : (x₁ , y₁) ~ (x₂ , y₂)) → Either (x₁ ≡ y₂) (y₁ ≡ y₂) 
y₂-equals refl₁ = right refl
y₂-equals refl₂ = left refl

ex₁ : (1 , 2) ~ (1 , 2)
ex₁ = refl₁

ex₂ : (1 , 2) ~ (2 , 1)
ex₂ = refl₂

open import Relation.Binary public
open import Relation.Nullary.Core public
open import Data.Empty

decidable-pair-equality : {A : Set} (_ : Decidable {A = A} _≡_) → Decidable {A = A × A} _~_ 
decidable-pair-equality (_==_??) (x₁ , y₁) (x₂ , y₂) with (x₁ == x₂ ??) | (x₁ == y₂ ??) | (y₁ == x₂ ??) | (y₁ == y₂ ??)
... | yes xx | _      | _      | yes yy rewrite xx | yy = yes refl₁
... | _      | yes xy | yes yx | _      rewrite xy | yx = yes refl₂
... | _      | _      | no yx  | no yy = no bc where
  bc : (x₁ , y₁) ~ (x₂ , y₂) → ⊥
  bc pf with y₁-equals pf
  ... | left e = yx e
  ... | right e = yy e
... | _      | no xy  | _      | no yy = no bc where
  bc : (x₁ , y₁) ~ (x₂ , y₂) → ⊥
  bc pf with y₂-equals pf
  ... | left e = xy e
  ... | right e = yy e
... | no xx  | no xy  | _      | _     = no bc where
  bc : (x₁ , y₁) ~ (x₂ , y₂) → ⊥
  bc pf with x₁-equals pf
  ... | left e = xx e
  ... | right e = xy e
... | no xx  | _      | no yx  | _     = no bc where
  bc : (x₁ , y₁) ~ (x₂ , y₂) → ⊥
  bc pf with x₂-equals pf
  ... | left e = xx e
  ... | right e = yx e
