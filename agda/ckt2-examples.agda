
module ckt2-examples where

open import ckt2
open import Data.Nat
open import Data.Fin using (#_)
open import Data.List hiding (or; and)
open import Data.String using (String)
open import Data.Product
open import Data.Maybe
open import Relation.Binary.PropositionalEquality

my-design-1 : CC-Design
my-design-1 = no-wires
  >add-a-wire> input 3
  
my-design-2 = no-wires
  >add-a-wire> input 14
  >add-a-wire> input 11
  >add-a-wire> not (another-wire (# 0)) and (another-wire (# 1))
  
infixl 3 _%>_
_%>_ : ∀ {l} → {A : Set l} → List A → A → List A 
xs %> x = x ∷ xs 

infixl 4 _<~_
_<~_ = _,′_

⟨_⟩ = another-wire'

my-proto-design-3 : List (String × Proto-Expr)
my-proto-design-3 = []
  %> "x" <~ input' 14
  %> "y" <~ input' 11
  %> "z" <~ ⟨ "x" ⟩ and' ⟨ "y" ⟩
  
my-design-3 : CC-Design
my-design-3 = from-just (compile-proto-design my-proto-design-3) 

my-proto-design-4 : List (_ × _)
my-proto-design-4 = []
  %> "x" <~ ⟨ "y" ⟩
  %> "y" <~ ⟨ "x" ⟩

my-design-4 = compile-proto-design my-proto-design-4
rejected-4 : my-design-4 ≡ nothing
rejected-4 = refl
