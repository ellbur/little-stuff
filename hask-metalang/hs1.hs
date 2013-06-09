
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}

import Data.HList
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import DynBind
import MetaLang

$(makeLabels ["lx", "ly", "lz"])

dExp1 = $(dbl [|
        ( (dv lx) + (dv ly) ) * 3
        + (dv lz)
    |])

b1 =
    lx .=. 2 .*.
    ly .=. 8 .*.
    lz .=. 1 .*.
    emptyRecord

dExp2 = $(dbl [|
        (dv lx) ++ " (ish)"
    |])

b2 =
    lx .=. "It works!" .*.
    emptyRecord

dExp3 = $(dbl [|
        [(dv lx), (dv ly)]
    |])

b3 =
    lx .=. ':' .*.
    ly .=. ')' .*.
    emptyRecord

dExp4 = $(dbl [|
        ((dv lx), (dv ly))
    |])

b4 =
    lx .=. ':' .*.
    ly .=. ')' .*.
    emptyRecord

dExp5 = $(dbl [|
        ((dv lx) :: Int) + 2
    |])

b5 =
    lx .=. 3 .*.
    emptyRecord

dExp6 = $(dbl [|
    if (dv lx) > 5
       then "Hello"
       else "Goodbye"
   |])

b6 =
    lx .=. 3 .*.
    emptyRecord

dExp7 = $(dbl [|
        [3 .. (dv lx)]
    |])

b7 =
    lx .=. 10 .*.
    emptyRecord

main = do
    print $ with b1 dExp1
    print $ with b2 dExp2
    print $ with b3 dExp3
    print $ with b4 dExp4
    print $ with b5 dExp5
    print $ with b6 dExp6
    print $ with b7 dExp7

