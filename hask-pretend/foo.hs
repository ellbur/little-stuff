
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}

import Data.HList
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

$(label "a")
$(label "b")

foo =
    a .=. 7 .*.
    b .=. 5 .*.
    emptyRecord

main = do
    print foo


