
module InstanceProblems2 where

open import Data.Nat
open import Data.String
open import Data.Maybe

data Foo (A : Set) : Set where
  foo : A → Foo A
  
theFooNat : Foo ℕ
theFooNat = foo 3

x : {{_ : Foo ℕ}} → Maybe ℕ 
x {{foo zero}} = nothing
x {{foo (suc n)}} = just n

y : ℕ
y = from-just x
