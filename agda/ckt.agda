
module ckt where

-- --------------------------------------------------------
-- Mini verilog-subset-ish model.
-- This is what we generate.

open import Data.String renaming (_++_ to _+s+_)
open import Data.Nat
open import Data.Nat.Show renaming (show to showNat)
open import Data.List
open import Coinduction

-- Definitions of the structures

-- Mutually recursive definitions
data VExp : Set
record VWire : Set
record VReg : Set
data VNet : Set

data VExp where
    aNum : ℕ -> VExp
    aWire : (w : ∞ VWire) -> VExp
    aReg : (w : ∞ VReg) -> VExp
    vu-_ : VExp -> VExp
    _v+_ : VExp -> VExp -> VExp
    _v*_ : VExp -> VExp -> VExp
    _v-_ : VExp -> VExp -> VExp
    _v/_ : VExp -> VExp -> VExp
    v~_  : VExp -> VExp
    _ v[ _ , _ ] : (n : ∞ VNet) -> ℕ -> ℕ -> VExp

record VWire where
    field
        name  : String
        width : ℕ
        value : VExp

record VReg where
    field
        name  : String
        width : ℕ
        value : VExp
        
data VNet where
    aWire : VWire -> VNet
    aReg  : VReg  -> VNet
    
netName : VNet -> String
netName (aWire w) = VWire.name w
netName (aReg r) = VReg.name r

record VModule : Set where
    field
        -- Note the absence of ports so far.
        name  : String
        wires : List VWire
        regs  : List VReg

-- Produces a source string from an expression
expStr : VExp -> String
expStr (aNum n) = showNat n
expStr (aWire w) = VWire.name (♭ w)
expStr (aReg r) = VReg.name (♭ r)
expStr (vu- x) = "-(" +s+ (expStr x) +s+ ")"
expStr (x v+ y) = "(" +s+ (expStr x) +s+ ") + (" +s+ (expStr y) +s+ ")"
expStr (x v* y) =  "(" +s+ (expStr x) +s+ ") * (" +s+ (expStr y) +s+ ")"
expStr (x v- y) =  "(" +s+ (expStr x) +s+ ") - (" +s+ (expStr y) +s+ ")"
expStr (x v/ y) =  "(" +s+ (expStr x) +s+ ") / (" +s+ (expStr y) +s+ ")"
expStr (v~ x)   =  "~(" +s+ (expStr x) +s+ ")"
expStr ( t v[ a , b ]) = (netName (♭ t)) +s+ "[" + (showNat a) +s+ "-1:" +s+ (showNat b) +s+ "]"

widthStr : ℕ -> String
widthStr n = "[" +s+ (showNat n) +s+ "-1" +s+ ":0]"

netDeclStr : {t : Set} -> String -> (t -> ℕ) -> (t -> String) -> t -> String
netDeclStr style width name t =
       style
    +s+ " "
    +s+ (widthStr (width t))
    +s+ " "
    +s+ (name t)
    +s+ ";"

wireDeclStr : VWire -> String
wireDeclStr = netDeclStr "wire" VWire.width VWire.name

wireDefStr : VWire -> String
wireDefStr w = "assign "
    +s+ (VWire.name w)
    +s+ " = "
    +s+ (expStr (VWire.value w))
    
regDeclStr : VReg -> String
regDeclStr = netDeclStr "reg" VReg.width VReg.name

regDefStr : VReg -> String
regDefStr r =
       "always @(posedge clk) "
    +s+ (VReg.name r) +s+ " <= " +s+ (expStr (VReg.value r)) +s+ ";"

mkString : String -> List String -> String
mkString sep [] = ""
mkString sep (s ∷ []) = s
mkString sep (s1 ∷ (s2 ∷ ss))  = s1 +s+ sep +s+ (mkString sep (s2 ∷ ss))

mkString' : String -> List String -> String
mkString' sep [] = ""
mkString' sep (x ∷ xs) = x +s+ sep +s+ (mkString' sep xs)

-- Produces a source string for a module
modStr : VModule -> String
modStr mod =
    (
        "module " +s+ (VModule.name mod) +s+ "(clk);\n"
     +s+ "input clk;\n\n"
     +s+ wireDecls
     +s+ regDecls
     +s+ "\n"
     +s+ wireDefs
     +s+ regDefs 
     +s+ "endmodule")
    where
        wireDecls = mkString' "\n" (map wireDeclStr (VModule.wires mod))
        regDecls  = mkString' "\n" (map regDeclStr (VModule.regs mod))
        wireDefs  = mkString' "\n" (map wireDefStr (VModule.wires mod))
        regDefs   = mkString' "\n" (map regDefStr (VModule.regs mod))
        
-- --------------------------------------------------------
-- Testing by making a module!!

open import SimpleIO

main : Main
main = putStrLn (modStr mod) where
    cWidth = 32
    
    counter : VReg
    counter = record { name = "counter"; width = cWidth; value = (aReg (♯ counter)) v+ (aNum 1) }
    
    by8 : VWire
    by8 = record { name = "by8"; width = 1; value = (♯ counter) v[ 4 , 3 ]
    
    mod : VModule
    mod = record {
            name  = "main";
            wires = by8 ∷ [];
            regs  = counter ∷ []
        }

