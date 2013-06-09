
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}

import Leafify
import DynBind

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

$(makeLabels ["labX", "labY", "labZ"])

expr = [$lf|
        (labX + labY) * labX + labZ
    |]

bindings =
    labX .=. 5 .*.
    labY .=. 7 .*.
    labZ .=. 10 .*.
    emptyRecord

main = do
    print $ with bindings expr

