
module wordcount where

import Foreign.Haskell as Hask
open import IO.Primitive renaming (putStrLn to putStrLnCo)
open import Data.List
open import Data.String
open import Function using (_∘_)

-- Data.Nat is unary. This is terribly inefficient. Ideally
-- we would use Haskell numbers, but that is not convenient.
open import Data.Nat

-- Data.Nat.Show was written before Agda had typeclass support.
open import Data.Nat.Show renaming (show to showNat)
open import Data.Char

putStrLn = putStrLnCo ∘ toCostring

infixl 1 _>>_
postulate
    _>>_  : ∀ {a b} {A : Set a} {B : Set b} → IO A → (IO B) → IO B
{-# COMPILED _>>_  (\_ _ _ _ -> (>>)) #-}

module CmdlineArgs where
    {-# IMPORT System #-}
    postulate sysArgs : IO (List String)
    {-# COMPILED sysArgs (System.getArgs) #-}

module FileIO where
    {-# IMPORT System.IO #-}
    postulate Handle : Set
    {-# COMPILED_TYPE Handle System.IO.Handle #-}
    postulate hGetLine : Handle -> IO String
    {-# COMPILED hGetLine (System.IO.hGetLine) #-}
    postulate hGetContents : Handle -> IO String
    {-# COMPILED hGetContents (System.IO.hGetContents) #-}
    postulate IOMode : Set
    {-# COMPILED_TYPE IOMode System.IO.IOMode #-}
    postulate ReadMode : IOMode
    {-# COMPILED ReadMode (System.IO.ReadMode) #-}
    -- This won't work if it's not universe-polymorphic. I Don't know why.
    postulate withFile : ∀ {u} {A : Set u} -> String -> IOMode -> (Handle -> IO A) -> IO A
    {-# COMPILED withFile (\_ _ -> System.IO.withFile) #-}

open CmdlineArgs
open FileIO

wordsInString : String -> ℕ
wordsInString s = ws1 (toList s) where
    mutual
        ws1 : List Char -> ℕ
        ws1 [] = 0
        ws1 (' ' ∷ rest) = ws1 rest
        ws1 (c ∷ cs) = suc (ws2 cs)

        ws2 : List Char -> ℕ
        ws2 [] = 0
        ws2 (' ' ∷ rest) = ws1 rest
        ws2 (c ∷ cs) = ws2 cs

-- Agda does not have case expressions, so we use a local
-- function to pattern match.
main : IO Hask.Unit
main = sysArgs >>= doArgs where
    -- Agda's type inference is not as good as Haskell's;
    -- We have to specify some amount of signature.
    doArgs : _ -> _
    doArgs (path ∷ []) =
        withFile path ReadMode \hl ->
            hGetContents hl >>= \text ->
            let count = wordsInString text in
            putStrLn (showNat count)
    doArgs _ =
        putStrLn "Usage: wordcount <filename>"
