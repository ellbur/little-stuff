
{-# LANGUAGE TemplateHaskell #-}

import StrType
import LetterLabels

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

main = do
    let yo = 7
    print $ typeOf $(l "ab")


