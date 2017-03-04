
module Equality-Things where

open import Relation.Binary public
open import Relation.Binary.PropositionalEquality public
open import Relation.Nullary.Core public
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

