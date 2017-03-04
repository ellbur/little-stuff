
{-# OPTIONS --sized-types #-}

module ckt3-examples where

open import Data.Nat
open import Data.Fin
open import Data.Vec
open import Function using (_$_)

module directly where
    open import ckt3
    
    _and_ : {n i : ℕ} → Wire {n} {i} → Wire {n} {i} → Wire {n} {i} 
    _and_ a b = combine «and» (a ∷ b ∷ [])
    
    my-ckt-1 : Ckt 2 
    my-ckt-1 = ckt no-wires (input # 0)
    
    my-ckt-2 : Ckt 2
    my-ckt-2 = ckt no-wires
      ((input # 0) and (input # 1))
      
module with-builder where
    open import ckt3-builder
    open import ckt3 using (Ckt; Op; «and»; «or»)
    open import Data.Product
    open import Data.Maybe
    
    infixl 6 _and_
    _and_ = λ a b → combine «and» (a ∷ b ∷ [])
    infixl 6 _or_
    _or_ = λ a b → combine «or» (a ∷ b ∷ [])
    
    infixl 3 _%>_
    _%>_ : ∀ {l} → {A : Set l} {n : ℕ} → Vec A n → A → Vec A (suc n) 
    xs %> x = x ∷ xs 
    
    infixl 4 _<~_
    _<~_ = _,′_
    
    ⟨_⟩ = another-wire
    ⟨⟨_⟩⟩ = input_
    
    my-proto-ckt-3 : Proto-Ckt
    my-proto-ckt-3 = proto-ckt ("a" ∷ "b" ∷ [])
        []
        (another-wire "a")
        
    my-proto-ckt-4 : Proto-Ckt
    my-proto-ckt-4 = proto-ckt ("a" ∷ "b" ∷ [])
      []
      ((input "a") and (input "b"))
      
    my-ckt-5 : Ckt 3
    my-ckt-5 = from-just $ compile $ proto-ckt ("a" ∷ "b" ∷ "c" ∷ [])
      ([]
        %> "x" <~ ⟨⟨ "a" ⟩⟩ and ⟨⟨ "b" ⟩⟩
        %> "y" <~ ⟨⟨ "b" ⟩⟩ and ⟨⟨ "c" ⟩⟩
        %> "z" <~ ⟨⟨ "a" ⟩⟩ and ⟨⟨ "c" ⟩⟩)
      ( ⟨ "x" ⟩ or ⟨ "y" ⟩ or ⟨ "z" ⟩ )
      