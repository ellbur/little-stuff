
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}

import Data.HList
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

inf f = f (inf f)

pretend base label value =
    inf (\x ->
        hUpdateAtLabel label value (base x)
    )

safePretend base label value mask =
    hProjectByLabels mask
        (hUpdateAtLabel label value base)

$(makeLabels ["a", "b", "c", "p1", "p2"])
foo' x =
    a  .=. 7 .*.
    b  .=. 5 .*.
    c  .=. ((x#p1)#a + (x#p1)#b) .*.
    p1 .=. (safePretend x a 9 (a .*. b .*. HNil)) .*.
    p2 .=. (safePretend x a 9 (a .*. b .*. HNil)) .*.
    emptyRecord
foo = inf foo'

bar = pretend foo' b 12
    
main = do
    print foo
    print bar

