
module sqrt where

open import System.IO
open import Data.Nat
open import Data.Integer
open import Data.Nat
open import Trim 
open import StrToNum

main : IO Unit
main =
       putStr "Number: "
    >> commit
    >> getStr >>= λ numStr
    -> let num = strToNum (trim numStr)
    in putStr (show num)
    >> putStr "\n"
    >> commit

