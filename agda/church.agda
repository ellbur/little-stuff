
module church where

open import Level
open import Data.Nat hiding (zero; suc; _⊔_)

data _types_ {l : Level} (A : Set l) (x : A) : Set (suc l) where
  obviously : _types_ {l} A x

maybe : {l : Level} → (A : Set l) → Set (suc zero ⊔ l)
maybe {l} A = (R : Set) → (f : R) → (g : A → R) → R

just3 : (R : Set) → (f : R) → (g : ℕ → R) → R
just3 R f g = g 3

check : (maybe ℕ) types just3
check = obviously

just : {l : Level} → {A : Set l} → (a : A) → maybe A
just {l} {A} a = match where
  match : (R : Set) → (f : R) → (g : A → R) → R
  match R f g = g a

nothing : {l : Level} → {A : Set l} → maybe A
nothing {l} {A} = match where
  match : (R : Set) → (f : R) → (g : A → R) → R
  match R f g = f

justMaybeNat : maybe ℕ → maybe (maybe ℕ)
justMaybeNat m = just m

open import Data.String renaming (_++_ to _+s+_)
open import Data.Nat.Show renaming (show to showNat)

x : maybe ℕ
x = just 3

showMaybe : ∀ {l} → {A : Set l} → (i : A → String) → (m : maybe A) → String
showMaybe i m = m _ "Nothing" (λ x → "Just " +s+ (i x))

-----------------------------------------------

pair : ∀ {l} (A : Set l) → (B : Set l) → Set (suc zero ⊔ l)
pair A B = (R : Set) → (f : A → B → R) → R

cons : ∀ {l} {A : Set l} → {B : Set l} → (a : A) → (b : B) → pair A B
cons a b = λ R f → f a b

open import Coinduction

plist : ∀ {l} (A : Set l) → Set ?
plist A = (R : Set) → (f : A → ♯ (plist A) → R) → (g : R) → R

