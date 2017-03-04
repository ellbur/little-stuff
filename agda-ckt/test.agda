
module test where

open import Verilog
open import SimpleIO
open import Coinduction
open import Data.Nat
open import Data.List

main : Main
main = putStrLn (modStr mod) where
    cWidth = 32
    
    counter : VReg
    counter = record { name = "counter"; width = cWidth; value = (aReg (♯ counter)) v+ (aNum 1) }
    
    by8 : VWire
    by8 = record { name = "by8"; width = 1; value = (♯ (aReg counter)) v[ 4 , 3 ] }
    
    mod : VModule
    mod = record {
            name  = "main";
            wires = by8 ∷ [];
            regs  = counter ∷ []
        }


