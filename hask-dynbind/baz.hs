
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}

import StrType
import LetterLabels
import DynBind

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1

main = do
    let labA = $(l "a")
    let labB = $(l "b")
        
    let er = emptyRecord

    let exp1 = (leaf (-)) <*> (leaf 5) <*> (dynVar labA)
    let exp2 = (leaf (-)) <*> (dynVar labA) <*> (dynVar labB)

    print $ extract $ bind labA 2 exp1
    print $ with (labA .=. 2 .*. er) exp1
    print $ with (labA .=. 5 .*. labB .=. 2 .*. er) exp1
    print $ with (labB .=. 5 .*. labA .=. 2 .*. er) exp1

    print $ with (labA .=. 5 .*. labB .=. 2 .*. er) exp2
    print $ with (labB .=. 5 .*. labA .=. 2 .*. er) exp2
    
    print $ with (
            labA .=. 5 .*.
            labB .=. 2 .*. er
        ) $
        (leaf (+)) <*> (dynVar labA) <*> (
            (leaf (*)) <*> (leaf 7) <*> (dynVar labB)
        )


