
module bar where

open import System.IO
open import Data.Nat
open import Data.String
open import Data.Integer renaming (suc to sucZ)

showNat : ℕ → String
showNat n = show (+ n)

mutual
    bar : ℕ → ℕ
    bar 0 = 0
    bar (suc n) = suc (foo n)

    foo : ℕ → ℕ
    foo 0 = 0
    foo (suc n) = suc (bar n)

main : IO Unit
main = 
       putStr (showNat (foo 2))
    >> putStr "\n"
    >> commit

