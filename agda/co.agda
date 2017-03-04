
module co where

open import Coinduction

data FooBar : Set where
  foo : ∞ FooBar → FooBar
  bar : ∞ FooBar → FooBar
  
data Yo : Set
data Dawg : Set
data Yo where
  yo : ∞ Dawg → Yo
data Dawg where
  dawg : ∞ Yo → Dawg
  
fooChain : FooBar
fooChain = foo (♯ fooChain)

data Doll : Set where
  doll : ∞ Doll → Doll
  
lucy : Doll
lucy = doll (♯ lucy)

id : ∀ {l} {A : Set l} (x : A) → A
id x = x

lucy2 : Doll
lucy2 = doll (♯ (id lucy2))

open import Data.Unit

data UDoll : Set where
  udoll : ∞ (Unit → UDoll) → UDoll
  
brian : UDoll
brian = udoll (♯ (λ _ → brian))

open import Data.Product

data Dolls : Set where
  dolls : ∞ (Unit × Dolls) → Dolls
  
guysAnd : Dolls
guysAnd = dolls (♯ (unit ,′ guysAnd))

data Pair {i} (A B : Set i) : Set i where
  _and_ : A → B → Pair A B
  
data Dolly : Set where
  dolly : ∞ (Pair Unit Dolly) → Dolly
  
sheep : Dolly
sheep = dolly (♯ (unit and sheep))

sheep2 : Dolly
sheep2 = dolly (♯ (id (unit and sheep2)))

