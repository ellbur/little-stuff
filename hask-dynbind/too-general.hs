
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

$(makeLabels ["labX", "labY"])

data DynExp a b = DynExp (a -> b)

leaf x = DynExp (\t -> x)

dynVar label = DynExp grab where
    grab rec = rec # label

apply (DynExp f) (DynExp x) = DynExp g where
    g rec = (f rec) (x rec)

infixl <*>
a <*> b = apply a b

with hl (DynExp f) = f hl

expr rec = with rec $ (leaf (+)) <*> (dynVar labX) <*> (dynVar labY)
bindings =
    labX .=. 5 .*.
    labY .=. 3 .*.
    emptyRecord

main = do
    print "hi"

