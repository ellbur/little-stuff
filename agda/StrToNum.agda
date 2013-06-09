
module StrToNum where

open import Data.Integer
open import Data.Nat     renaming (_+_ to _+N_; _*_ to _*N_)
open import Data.List
open import Data.String
open import Data.Char

charToNum : Char → ℤ
charToNum c = m c where
    m : Char → ℤ
    m '0' = (+ 0)
    m '1' = (+ 1)
    m '2' = (+ 2)
    m '3' = (+ 3)
    m '4' = (+ 4)
    m '5' = (+ 5)
    m '6' = (+ 6)
    m '7' = (+ 7)
    m '8' = (+ 8)
    m '9' = (+ 9)
    m 'a' = (+ 10)
    m 'A' = (+ 10)
    m 'b' = (+ 11)
    m 'B' = (+ 11)
    m 'c' = (+ 12)
    m 'C' = (+ 12)
    m 'd' = (+ 13)
    m 'D' = (+ 13)
    m 'e' = (+ 14)
    m 'E' = (+ 14)
    m 'f' = (+ 15)
    m 'F' = (+ 15)
    m  _  = (+ 0)

strToNumRadIter : (List Char) → ℤ → ℤ → ℤ
strToNumRadIter [] rad sum = sum
strToNumRadIter (c ∷ cs) rad sum =
    (strToNumRadIter
        cs
        rad
        (rad * sum + (charToNum c)))

strToNumRad : (List Char) → ℤ → ℤ
strToNumRad str rad = strToNumRadIter str rad (+ 0)

strToNum' : (List Char) → ℤ
strToNum' str = strToNumRad str (+ 10)

strToNum : String → ℤ
strToNum str = strToNum' (toList str)

