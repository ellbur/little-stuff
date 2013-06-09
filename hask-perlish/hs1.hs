
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}

import System.IO
import Control.Monad.Reader

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

hGetLineDelim handle delim =
    hGetLineDelim' handle delim ""

-- Wow fully imperative code ;(
hGetLineDelim' handle delim buf = do
    c <- hGetChar handle
    if c == delim
       then do
           return $ reverse buf
       else do
           buf' <- hGetLineDelim' handle delim (c:buf)
           return buf'

getLineDelim = hGetLineDelim stdin

$(label "pipe")

perlHGetLineDelim handle = do
    delim <- asks (#pipe)
    return $ hGetLineDelim handle delim

runPerl prog =
    runReaderT prog defaultGlobals

defaultGlobals =
    pipe .=. '\n' .*.
    emptyRecord

setLocal label value =
    local (hUpdateAtLabel label value)

perlMain = do
    liftIO $ putStrLn "Beginning perlish"

    setLocal pipe 'a' $ do
        line <- perlHGetLineDelim stdin
        liftIO $ (line >>= putStrLn)

    setLocal pipe 'b' $ do
        line <- perlHGetLineDelim stdin
        liftIO $ (line >>= putStrLn)

    liftIO $ putStrLn "Ending perlish"

main = do
    runPerl perlMain

