
module genapplic where

open import IO.Primitive renaming (putStrLn to putStrLnCo)
open import Data.String
open import Data.Unit
open import Data.Bool
open import Function
import Foreign.Haskell as Hask

module MoreIO where

    infixl 1 _>>_

    postulate
        _>>_  : ∀ {a b} {A : Set a} {B : Set b} → IO A → (IO B) → IO B
        getLine : IO String

    {-# COMPILED _>>_  (\_ _ _ _ -> (>>)) #-}
    {-# COMPILED getLine (getLine) #-}

open MoreIO

record Show (a : Set) : Set where
    field show : a -> String

open Show {{...}}

showBool : Show Bool
showBool = record { show = show' } where
    show' : Bool -> String
    show' true = "true"
    show' false = "false"

showString : Show String
showString = record { show = show' } where
    show' : String -> String
    show' s = s

record GenApplic (K : Set1) (F : K -> Set -> Set1) : Set1 where
    field Pure : K
          Ap : K -> K -> K
          pure : ∀ {a} -> a -> F Pure a
          ap : ∀ {a b m1 m2} -> F m1 (a -> b) -> F m2 a -> F (Ap m1 m2) b

    _<$>_ : ∀ {a b m2} -> (a -> b) -> F m2 a -> F (Ap Pure m2) b
    _<$>_ f x = ap (pure f) x

    _<*>_ : ∀ {a b m1 m2} -> F m1 (a -> b) -> F m2 a -> F (Ap m1 m2) b
    _<*>_ = ap

    infixl 5 _<$>_
    infixl 5 _<*>_

open GenApplic {{...}}

data Mark : Set1 where
    hot : Mark
    cold : Mark

combine : Mark -> Mark -> Mark
combine cold cold = cold
combine _ _ = hot

data Tagged (m : Mark) (a : Set) : Set1 where
    tagged : a -> Tagged m a

taggedApplic : GenApplic Mark Tagged
taggedApplic = record { Pure = Pure' ; Ap = Ap' ; pure = pure' ; ap = ap' } where
    Pure' = cold

    Ap' : Mark -> Mark -> Mark
    Ap' = combine

    pure' : ∀ {a} -> a -> Tagged cold a
    pure' x = tagged x

    ap' : ∀ {a b m1 m2} -> Tagged m1 (a -> b) -> Tagged m2 a -> Tagged (combine m1 m2) b
    ap' (tagged f) (tagged x) = tagged (f x)

isHot : ∀ {a} -> {m : Mark} -> Tagged m a -> Bool
isHot {m = hot} _ = true
isHot _ = false

extract : ∀ {a m} -> Tagged m a -> a
extract (tagged x) = x

xHot : Tagged hot String
xHot = tagged "hello"

xCold : Tagged cold String
xCold = tagged ", there"

twice : String -> _
twice s = s ++ s

cat : String -> String -> String
cat s1 s2 = s1 ++ s2

cat3 : _ -> _ -> _ -> _
cat3 s1 s2 s3 = s1 ++ s2 ++ s3

xCombine : Tagged _ String
xCombine = cat3 <$> xHot <*> xCold <*> xHot

putStrLn = putStrLnCo ∘ toCostring

print : ∀ {a} -> {{s : Show a}} -> a -> IO Hask.Unit
print = putStrLn ∘ show

main : IO Hask.Unit
main =
    print (extract xCombine) >>
    print (isHot xCombine)

