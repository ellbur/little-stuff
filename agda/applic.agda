
module applic where

open import IO.Primitive
open import Data.String
open import Data.Unit
open import Function

import Foreign.Haskell as Hask

-- ------------------------------

data Thing (a : Set) : Set where
    thing : a -> Thing a

-- ------------------------------

record Functor (F : Set -> Set) : Set1 where
    field fmap : ∀ {a b} -> (a -> b) -> F a -> F b

open Functor {{...}}

thingFunctor : Functor Thing
thingFunctor = record { fmap = fmap' } where
    fmap' : ∀ {a b} -> (a -> b) -> Thing a -> Thing b
    fmap' f (thing x) = thing (f x)

-- ------------------------------

record Applicative (F : Set -> Set) : Set1 where
    field pure : ∀ {a} -> a -> F a
          ap : ∀ {a b} -> F (a -> b) -> F a -> F b

open Applicative {{...}}

thingApp : Applicative Thing
thingApp = record { pure = pure' ; ap = ap' } where
    pure' : ∀ {a} -> a -> Thing a
    pure' x = thing x

    ap' : ∀ {a b} -> Thing (a -> b) -> Thing a -> Thing b
    ap' (thing f) (thing x) = thing (f x)

-- ------------------------------

twice = \s -> s ++ s

th : Thing String
th = pure "Hello"

th2 = fmap twice th

putStrLn' = putStrLn ∘ toCostring

msg : _
msg with th2
... | thing str = str

main : IO Hask.Unit
main =
    putStrLn' msg

