
module Ordinals where

data Bit : Set where
  b0 : Bit
  b1 : Bit
  
-- This is really pretty tricky.
data Ordinal : Set where
  ⊘ : Ordinal
  _~_ : Bit → Ordinal → Ordinal
  
x = b0 ~ ⊘ 
y = b1 ~ ⊘
