
module foo where

open import System.IO
open import Data.Nat
open import Data.String
open import Data.Integer renaming (suc to sucZ)

showNat : ℕ → String
showNat n = show (+ n)

bar : (ℕ → ℕ) → ℕ → ℕ
bar f 0 = 0
bar f (suc n) = suc (f n)

foo : ℕ → ℕ
foo 0 = 0
foo (suc n) = suc (bar foo n)

main : IO Unit
main = 
       putStr (showNat (foo 2))
    >> putStr "\n"
    >> commit

