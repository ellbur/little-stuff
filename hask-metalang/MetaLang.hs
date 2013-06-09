
{-# LANGUAGE TemplateHaskell #-}

module MetaLang where

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Monad
import Control.Applicative

import PointFree
import ExpUtils
import Simplify
import PointFreeify

data MetaLang = MetaLang {
        ml_keyword   :: Name -> Q (Maybe Exp),
        ml_leaf      :: Q Exp,
        ml_apply     :: Q Exp
    }

lf :: a -> a
lf = undefined

nd :: a -> b
nd = undefined

meta :: MetaLang -> Q Exp -> Q Exp
meta lang qx = do
    x   <- qx
    x'  <- expToSimpExp x
    x'' <- simpExpToPointFreeExp x'
    y   <- meta' lang [] x''
    let y' = pointFreeExpToExp y
    return $ y'

meta' :: MetaLang -> [Name] -> PointFreeExp -> Q PointFreeExp
meta' lang names (VarPFE n) = metaVar lang names n
meta' lang names (ConPFE n) = metaCon lang names n
meta' lang names (LitPFE l) = metaLit lang names l
meta' lang names (AppPFE x1 x2) = metaApp lang names x1 x2
meta' lang names (LetPFE decs x) = metaLet lang names decs x
meta' lang names x@(MessyPFE _ _) = addLeaf lang x

metaVar :: MetaLang -> [Name] -> Name -> Q PointFreeExp
metaVar lang names n = do
    if n `elem` names
       then return $ VarPFE n
       else addLeaf lang (VarPFE n)

addLeaf :: MetaLang -> PointFreeExp -> Q PointFreeExp
addLeaf lang x = do
    leaf <- ml_leaf lang
    return $ AppPFE (MessyPFE "leaf" leaf) x

metaCon :: MetaLang -> [Name] -> Name -> Q PointFreeExp
metaCon lang names n = addLeaf lang (ConPFE n)

metaLit :: MetaLang -> [Name] -> Lit -> Q PointFreeExp
metaLit lang names l = addLeaf lang (LitPFE l)

metaApp :: MetaLang -> [Name] ->
    PointFreeExp -> PointFreeExp -> Q PointFreeExp
metaApp lang names x1@(VarPFE n) x2 = do
    check <- metaKeyword lang n
    case check of
         Just kw -> return $ AppPFE (MessyPFE "kw" kw) x2
         Nothing -> metaCall lang names x1 x2
metaApp lang names x1 x2 =
    metaCall lang names x1 x2

metaCall :: MetaLang -> [Name] ->
    PointFreeExp -> PointFreeExp -> Q PointFreeExp
metaCall lang names x1 x2 = do
    x1' <- meta' lang names x1
    x2' <- meta' lang names x2
    ap  <- ml_apply lang
    return $ AppPFE (AppPFE (MessyPFE "ap" ap) x1') x2'

metaKeyword :: MetaLang -> Name -> Q (Maybe Exp)
metaKeyword lang n = do
    VarE nLf <- [|lf|]
    VarE nNd <- [|nd|]
    let res | n == nLf = Just <$> (ml_leaf lang)
            | n == nNd = Just <$> [|id|]
            | True     = ml_keyword lang n
    res

metaLet :: MetaLang -> [Name] -> [PointFreeDec] ->
    PointFreeExp -> Q PointFreeExp
metaLet lang names decs x = do
    let names' = [n | DecPFD n _ <- decs] ++ names
    x'    <- meta' lang names' x
    decs' <- sequence $ map (metaDec lang names') decs
    return $ LetPFE decs' x'

metaDec :: MetaLang -> [Name] -> PointFreeDec -> Q PointFreeDec
metaDec lang names (DecPFD n x) = DecPFD n <$> x' where
    x' = meta' lang names x


