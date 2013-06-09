
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE DeriveDataTypeable #-}

module DynBind where

import Data.HList hiding (apply,Apply)
import Data.HList.Label4
import Data.HList.TypeEqGeneric1
import Data.HList.TypeCastGeneric1
import Data.HList.MakeLabels

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Applicative

import MetaLang
import ExpUtils

data DynExp a b = DynExp (a -> b)

leaf :: v -> DynExp (Record HNil) v
leaf x = DynExp (\t -> x)

dynVar :: label -> DynExp (Record (HCons (LVPair label v) HNil)) v
dynVar label = DynExp grab where
    grab (Record (HCons (LVPair v) HNil)) = v

apply (DynExp f) (DynExp x) = DynExp (splitApply f x)

splitApply :: (
        HLeftUnion (Record hl1) (Record hl2) (Record hlU),
        H2ProjectByLabels ls1 hlU hl1' uu1,
        H2ProjectByLabels ls2 hlU hl2' uu2,
        HRearrange ls1 hl1' hl1,
        HRearrange ls2 hl2' hl2,
        HLabelSet ls1,
        HLabelSet ls2,
        HRLabelSet hl1',
        HRLabelSet hl2',
        RecordLabels hl1 ls1,
        RecordLabels hl2 ls2
    ) =>
    (Record hl1 -> a -> b) ->
    (Record hl2 -> a) ->
    Record hlU ->
    b
splitApply f x hl = f (hMoldByType hl) (x (hMoldByType hl))

-- Can you believe this works?
hMoldByType r1 = r2 where
    r2 = hRearrange r2Labels $ hProjectByLabels r2Labels r1
    r2Labels = recordLabels r2

with hl (DynExp f) = f $ hMoldByType hl

dbCall (DynExp f) b = f b

-- Dynamic binding Meta Langugae

dv :: a -> b
dv l = error "This is a placeholder"

dynBindMetaLang = MetaLang {
        ml_keyword = dynBindKeyword,
        ml_leaf    = [|leaf|],
        ml_apply   = [|apply|]
    }

dbl = meta dynBindMetaLang

dynBindKeyword :: Name -> Q (Maybe Exp)
dynBindKeyword n = dynBindKeyword' <*> (return n)

dynBindKeyword' :: Q (Name -> Maybe Exp)
dynBindKeyword' = do
    nDv     <- expName <$> [|dv|]
    eDynVar <- [|dynVar|]
    let f n | (n == nDv) = Just eDynVar
            | True       = Nothing
    return f

