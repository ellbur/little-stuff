
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ImplicitParams #-}
--{-# LANGUAGE NoMonomorphismRestriction #-}

import Data.HList
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

$(makeLabels ["x", "y", "z"])

foo =
    x .=. 5 .*.
    y .=. 7 .*.
    emptyRecord

c = let
        ?x = foo#x
        ?y = foo#y
    in ?x + ?y

main = do
    print c

