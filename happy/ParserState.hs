
module ParserState where

import Control.Monad.Error

type PR = ErrorT ParseError IO

returnPR :: a -> PR a
returnPR = return

bindPR :: PR a -> (a -> PR b) -> PR b
bindPR = (>>=)

data ParseError = ParseError String

parseError s = throwError $ ParseError s

instance Show ParseError where
    show (ParseError s) = s

instance Error ParseError where
    noMsg = ParseError "Unknown error"
    strMsg s = ParseError s
    

