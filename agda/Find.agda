
module Find where

open import Equality-Things
open import Functor-Things
open import Data.Nat
open import Data.Fin renaming (zero to zeroFin; suc to sucFin)
open import Data.Vec renaming ([] to []v; _∷_ to _∷v_)
open import Data.Maybe

find : ∀ {A} → {{_ : A-DE A}} → {n : ℕ} → Vec A n → A → Maybe (Fin n)
find []v _ = nothing
find (x′ ∷v v′) x with x′ == x ??
...              | yes _ = just zeroFin
...              | no _  = find v′ x >map> sucFin

