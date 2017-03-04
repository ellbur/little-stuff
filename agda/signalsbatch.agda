
module signalsbatch where

data Bit : Set where
  b0 : Bit
  b1 : Bit

open import Data.Unit using (Unit; unit)

open import Coinduction
open import Data.Product

data Program : Set where
  step : (∞ (Bit → Bit × Program)) → Program

allZeros : Program
allZeros = step (♯ (λ _ → b0 ,′ allZeros))
