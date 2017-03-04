
module signals where

data Bit : Set where
  b0 : Bit
  b1 : Bit
  
open import Data.Unit using (Unit; unit)

-- This is like a cute way of defining what would otherwise be postulates.
-- I like this feature of Agda.
module inner
    (IO : Set)
    (writeBit : Bit → {A : Set} → (c : IO → A) → IO → A)
    (readBit : {A : Set} → (c : Bit → IO → A) → IO → A)
  where
  
    Program : Set
    Program = IO → Unit
    
    myProgram : Program
    myProgram = λ io → unit
    
module inner2 where

    data Program : Set where
      done     : Program
      readBit  : (Bit → Program) → Program
      writeBit : Bit → Program → Program
      
    open import Data.Nat
    open import Relation.Nullary.Core using (yes; no)
    open import Relation.Binary.PropositionalEquality
    
    onesFiveTimes : Program
    onesFiveTimes = iter 5 where
      iter : ℕ → Program
      iter 0 = done
      iter (suc n) = writeBit b1 (iter n)
      
    counting : Program
    counting = iter 5 0 0 where
      iter : ℕ → ℕ → ℕ → Program
      iter zero k0 k1 with (k0 ≤? k1)
      ...                 | yes _ = writeBit b0 done
      ...                 | no _ = writeBit b1 done
      iter (suc n) k0 k1 = readBit continue where
        continue : Bit → Program
        continue b0 = iter n (suc k0) k1
        continue b1 = iter n k0 (suc k1)
        
    -- Still trying to get an idea of what exactly a signal is.
    counting2-templ : (ℕ → ℕ → Program → Program) → Program
    counting2-templ receiver = iter 5 0 0 where
      iter : ℕ → ℕ → ℕ → Program
      iter zero k0 k1 = receiver k0 k1 done
      iter (suc n) k0 k1 = readBit continue where
        continue : Bit → Program
        continue b0 = iter n (suc k0) k1
        continue b1 = iter n k0 (suc k1)
        
    counting2 : Program
    counting2 = counting2-templ theEnd where
      theEnd : ℕ → ℕ → Program → Program
      theEnd k0 k1 rest with (k0 ≤? k1)
      ...              | yes _ = writeBit b0 rest
      ...              | no _  = writeBit b1 rest
      
    Signal : ∀ {l} → Set l → Set l
    Signal a = (a → Program → Program) → Program
    
    open import Data.Product
    
    counting3-templ : Signal (ℕ × ℕ)
    counting3-templ receiver = iter 5 0 0 where
      iter : ℕ → ℕ → ℕ → Program
      iter zero k0 k1 = receiver (k0 ,′ k1) done
      iter (suc n) k0 k1 = readBit continue where
        continue : Bit → Program
        continue b0 = iter n (suc k0) k1
        continue b1 = iter n k0 (suc k1)
        
    signalToProgram : Signal Unit → Program
    signalToProgram s = s (λ _ z → z)
    
    mapSignal : ∀ {l} → {A B : Set l} → Signal A → (A → B) → Signal B
    mapSignal s f = λ contB → s (λ a → contB (f a))
    
module inner3 where

    open import Coinduction
    open import Data.Product
    
    data Program : Set where
      step : (Bit → Bit × ∞ Program) → Program
      
    allZeros' : ∞ Program
    allZeros' = ♯ (step foo) where
      foo : Bit → Bit × ∞ Program
      foo b = b0 , allZeros'
      
    allZeros : Program
    allZeros = step foo where
      foo : Bit → Bit × ∞ Program
      foo b = b0 , (♯ allZeros)
      
    allZeros3-1 : Program
    allZeros3-2 : Bit → Bit × ∞ Program
    allZeros3-1 = step allZeros3-2
    allZeros3-2 b = b0 , (♯ allZeros3-1)
    
    open import Data.Colist
    
    simulateWithZeros : Program → Colist Bit
    simulateWithZeros (step s) with s b0
    ...                       | proj₁ , proj₂ = proj₁ ∷ ♯ (simulateWithZeros (♭ proj₂))
    
module inner4 where

     open import Coinduction
     open import Data.Product
     
     data Program : Set where
       step : ∞ (Bit → Bit × Program) → Program
       
     allZeros : Program
     allZeros = step (♯ (λ _ → b0 , allZeros))