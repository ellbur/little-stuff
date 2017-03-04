
module ckt3 where

open import Data.Nat
open import Data.Fin renaming (zero to zeroFin; suc to sucFin)
open import Data.Vec renaming ([] to []v; _∷_ to _∷v_)

data Op : ℕ → Set where
  «and» : Op 2
  «or» : Op 2
  «not» : Op 1
  
data Wire {num-inputs : ℕ} {index : ℕ} : Set where
  input_ : Fin num-inputs → Wire
  combine : {arity : ℕ} → (op : Op arity)
    → (args : Vec (Wire {num-inputs} {index}) arity) → Wire
  another-wire : (its-index : Fin index) → Wire
  
data Extra-Wires (num-inputs : ℕ) : (num-wires : ℕ) → Set where
  no-wires : Extra-Wires num-inputs zero
  _>add-a-wire>_ : {num-wires′ : ℕ}
    → Extra-Wires num-inputs num-wires′
    → Wire {num-inputs} {num-wires′}
        → Extra-Wires num-inputs (suc num-wires′) 
        
record Ckt (num-inputs : ℕ) {num-extra-wires : ℕ} : Set where
  constructor ckt
  field
    extra-wires : Extra-Wires num-inputs num-extra-wires
    result : Wire {num-inputs} {num-extra-wires}
    
    