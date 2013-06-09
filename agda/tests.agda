
module tests where

open import Data.List
open import Data.Nat
open import Relation.Binary.PropositionalEquality

postulate TODO : ∀ {u} {A : Set u} -> A

prop1 : 1 ≡ 1
prop1 = refl

prop2 : (1 + 1) ≡ 2
prop2 = refl

prop3 : reverse (1 ∷ 2 ∷ 3 ∷ []) ≡ (3 ∷ 2 ∷ 1 ∷ [])
prop3 = refl

prop4 : {x y z : ℕ} -> reverse (x ∷ y ∷ z ∷ []) ≡ (z ∷ y ∷ x ∷ [])
prop4 = refl

prop5 : {x y z : ℕ} -> length (x ∷ y ∷ z ∷ []) ≡ 3
prop5 = refl

dseq : ℕ -> List ℕ
dseq 0 = []
dseq (suc n) = n ∷ (dseq n)

prop6 : dseq 3 ≡ (2 ∷ 1 ∷ 0 ∷ [])
prop6 = refl

seq : ℕ -> List ℕ
seq n = countUp 0 n where
    countUp : ℕ -> ℕ -> List ℕ
    countUp _ 0 = []
    countUp a (suc b) = a ∷ (countUp (suc a) b)

prop7 : seq 3 ≡ (0 ∷ 1 ∷ 2 ∷ [])
prop7 = refl

prop8 : {n : ℕ} -> reverse (seq n) ≡ dseq n
prop8 {0} = refl
prop8 {suc n} = TODO

