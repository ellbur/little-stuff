
module FlowExp where

-- A more dataflow-like DSL, that will be compiled into the Verilog DSL.

open import Data.String renaming (_++_ to _+s+_)
open import Data.Nat
open import Coinduction

data Signal (w : ℕ) : Set

data Signal where
    delay : {w : ℕ} -> Signal w -> Signal w
    zero  : {w : ℕ} -> Signal w
    _s+_  : {w : ℕ} -> Signal w -> Signal w -> Signal w

infixl 6 _s+_

x : Signal 10
x = zero
y = delay x
z = x s+ y
w = z s+ (delay z) s+ (delay (delay z))

