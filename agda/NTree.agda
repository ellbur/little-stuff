
{-# OPTIONS --sized-types #-}

module NTree where

open import Data.List
open import Data.Nat

module The-Problem where
    data NTree : Set where
      leaf : ℕ → NTree 
      branch : (branches : List NTree) → NTree  
      
    my-ntree : NTree
    my-ntree = branch (leaf 3 ∷ leaf 4 ∷ [])
    
    ntree-sum : NTree → ℕ
    ntree-sum (leaf x) = x
    ntree-sum (branch branches) = sum (map ntree-sum branches)
    
module An-Attempt-At-Solution-1 where
    open import Size
    
    data NTree : {i : Size} → Set where
      leaf : {j : Size} → ℕ → NTree {↑ j} 
      branch : {j : Size} (branches : List (NTree {j})) → NTree {↑ j}   
      
    my-ntree : NTree
    my-ntree = branch (leaf 3 ∷ leaf 4 ∷ [])
    
    ntree-sum : {i : Size} (tree : NTree {i}) → ℕ
    ntree-sum .{↑ i} (leaf {i} x) = x
    ntree-sum .{↑ i} (branch {i} branches) = sum (map ntree-sum branches)
    
    yo = ntree-sum my-ntree
    
open An-Attempt-At-Solution-1
