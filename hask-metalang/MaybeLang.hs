
{-# LANGUAGE TemplateHaskell #-}

module MaybeLang where

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Monad
import Control.Applicative

import MetaLang
import ExpUtils

maybeLang = meta $ maybeLang'
maybeLang' = MetaLang {
        ml_keyword = maybeKeyword,
        ml_leaf    = [|maybeLeaf|],
        ml_apply   = [|maybeApply|]
    }

n :: a -> b
n = undefined

n_ :: a -> Maybe b
n_ = const Nothing

maybeKeyword :: Name -> Q (Maybe Exp)
maybeKeyword n = maybeKeyword' <*> (return n)

maybeKeyword' :: Q (Name -> Maybe Exp)
maybeKeyword' = do
    nN <- expName <$> [|n|]
    eN <- [|n_|]
    let f n | (n == nN) = Just eN
            | True      = Nothing
    return f

maybeLeaf :: a -> Maybe a
maybeLeaf = pure

maybeApply :: Maybe (a -> b) -> Maybe a -> Maybe b
maybeApply = (<*>)

