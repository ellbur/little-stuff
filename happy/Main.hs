
{-# LANGUAGE NoImplicitPrelude #-}

import Prelude hiding (lex)

import ParserState
import Lexer
import Liner
import Parser

import Control.Monad.Error

main' :: PR ()
main' = do
    input <- lift $ readFile "input.txt"
    lift $ print input
    
    let tokens = lex input
    lift $ print tokens

    stokens <- smoothLines tokens
    lift $ print stokens
    
    expr <- parse stokens
    lift $ print expr

main :: IO ()
main = do
    res <- runErrorT main'
    case res of
         Left e  -> print e
         Right _ -> return ()

