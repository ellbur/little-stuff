
module foo3 where

open import Data.Nat
open import Data.String
open import Relation.Binary.PropositionalEquality

data Dawg : Set where
  dawg : String → String → Dawg

data Yo : Set where
  yo : String → Yo

data OCS : Set₁ where
  empty : OCS
  aC : Set → OCS → OCS

st₁ : Yo ≡ Yo
st₁ = refl

data TSDef : Set → Set₁ where
  tsDef : {A : Set} → (A → String) → TSDef A

yoStringDef : TSDef Yo
yoStringDef = tsDef ?
