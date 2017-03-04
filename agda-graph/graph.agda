
module graph where

open import Data.Nat as Nat
open import Data.Nat.Properties using (strictTotalOrder)
import Data.AVL.IndexedMap as IMap
open import Relation.Binary using (module StrictTotalOrder)

open StrictTotalOrder strictTotalOrder using (isStrictTotalOrder)

x : ℕ
x = {!!}

open module NatMap = IMap { Key = λ _ → ℕ } ( λ _ → ℕ ) { _<_ = {!!} } {!!}
