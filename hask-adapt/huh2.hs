
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

$(makeLabels ["labA", "labB"])

rec1 = 
    labA .=. (5::Int) .*.
    labB .=. (7::Int) .*.
    emptyRecord

--rec2 :: Record (HCons (LVPair (Proxy LabA) Int) HNil)
--rec2 = hProjectByLabels rec2Labels rec1

--rec2Labels = recordLabels rec2

-- Can you believe this works?
hProjectByType r1 = r2 where
    r2 = hProjectByLabels r2Labels r1
    r2Labels = recordLabels r2

rec2 :: Record (HCons (LVPair (Proxy LabA) Int) HNil)
rec2 = hProjectByType rec1

main = do
    print rec1
    print rec2

