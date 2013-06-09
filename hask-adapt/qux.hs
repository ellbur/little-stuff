
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
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

data DynExp a b = DynExp (a -> b)

leaf :: v -> DynExp (Record HNil) v
leaf x = DynExp (\t -> x)

dynVar :: label -> DynExp (Record (HCons (LVPair label v) HNil)) v
dynVar label = DynExp grab where
    grab (Record (HCons (LVPair v) HNil)) = v

apply (DynExp f) (DynExp x) = DynExp (splitApply f x)

splitApply :: (
        HLeftUnion (Record hl1) (Record hl2) (Record hlU),
        H2ProjectByLabels ls1 hlU hl1 uu1,
        H2ProjectByLabels ls2 hlU hl2 uu2,
        HRLabelSet hl1,
        HRLabelSet hl2,
        HRLabelSet hlU,
        RecordLabels hl1 ls1,
        RecordLabels hl2 ls2
    ) =>
    (Record hl1 -> a -> b) ->
    (Record hl2 -> a) ->
    Record hlU ->
    b
splitApply f x hl = f (hProjectByType hl) (x (hProjectByType hl))

-- Can you believe this works?
hProjectByType r1 = r2 where
    r2 = hProjectByLabels r2Labels r1
    r2Labels = recordLabels r2

hMoldByType r1 = r2 where
    r2 = hRearrange r2Labels $ hProjectByLabels r2Labels r1
    r2Labels = recordLabels r2

infixl <*>
a <*> b = apply a b

extract (DynExp f) = f emptyRecord

bind label value (DynExp f) = DynExp g where
    g hl = f ((label .=. value) .*. hl)

with hl (DynExp f) = f $ hMoldByType hl

$(makeLabels ["labA", "labB"])
er = emptyRecord

main = do
    --let exp = (leaf (-)) <*> (dynVar labA) <*> (dynVar labB)
    let exp1 = (leaf (-)) <*> (leaf 5) <*> (dynVar labA)
    let exp2 = (leaf (-)) <*> (dynVar labB) <*> (dynVar labA)

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

