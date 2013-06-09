
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Leafify where

import DynBind
import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.Meta.Parse
import Data.List.Utils

var str = VarE (mkName str)
vLeaf   = var "leaf"
vDynVar = var "dynVar"
vApply  = var "apply"
vFlip   = var "flip"

fromRight (Right x) = x

lf = QuasiQuoter {
    quoteExp = doLf,
    quotePat = doLfPat
}

doLf :: String -> Q Exp
doLf str = do
    return $ leafify' $ fromRight $ parseExp str

doLfPat :: String -> Q Pat
doLfPat str = do
    return $ WildP

infixl <**>
a <**> b = AppE a b

leafify' :: Exp -> Exp
leafify' (VarE v) =
    let name = nameBase v in
        if startswith "lab" name
        then vDynVar <**> (VarE v)
        else vLeaf <**> (VarE v)
leafify' (ConE x) = vLeaf <**> (ConE x)
leafify' (LitE x) = vLeaf <**> (LitE x)
leafify' (AppE f x) = vApply <**> (leafify' f) <**> (leafify' x)
leafify' (InfixE Nothing op Nothing) =
    vLeaf <**> (InfixE Nothing op Nothing)
leafify' (InfixE (Just a) op Nothing) = expr where
    expr = vApply <**> (vLeaf <**> f) <**> (leafify' a)
    f    = InfixE Nothing op Nothing
leafify' (InfixE Nothing op (Just b)) = expr where
    expr = vApply <**> (vLeaf <**> f) <**> (leafify' b)
    f    = vFlip <**> (InfixE Nothing op Nothing)
leafify' (InfixE (Just a) op (Just b)) = expr where
    expr  = vApply <**> expr1 <**> (leafify' b)
    expr1 = vApply <**> (vLeaf <**> f) <**> (leafify' a)
    f     = InfixE Nothing op Nothing
leafify' (LamE ps x) = LamE ps (leafify' x)
leafify' (TupE xs) = TupE (fmap leafify' xs)
leafify' (CondE x y z) =
    CondE (leafify' x) (leafify' y) (leafify' z)
leafify' (ListE xs) = ListE (fmap leafify' xs)

-- Not Implemented
--leafify' (LetE d x)
--leafify' (CaseE x m)
--leafify' (DoE sts)
--leafify' (CompE sts)
--leafify' (ArithSeqE r)
--leafify' (SigE x t)
--leafify' (RecConE n fes)
--leafify' (RecUpdE x fes)

leafify :: Q Exp -> Q Exp
leafify qexp = do
    exp <- qexp
    return $ leafify' exp

