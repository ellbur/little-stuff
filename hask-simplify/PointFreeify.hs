
{-# LANGUAGE TemplateHaskell #-}

module PointFreeify where

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Monad
import Control.Applicative

import PointFree
import Simple
import ExpUtils

simpExpToPointFreeExp :: SimpExp -> Q PointFreeExp
simpExpToPointFreeExp = se2pfe []

se2pfe :: [Name] -> SimpExp -> Q PointFreeExp
se2pfe args (VarSE n) = extract args n
se2pfe args (ConSE n) = constify args $ ConPFE n
se2pfe args (LitSE l) = constify args $ LitPFE l
se2pfe [] (AppSE x1 x2) = do
    x1' <- se2pfe [] x1
    x2' <- se2pfe [] x2
    return $ AppPFE x1' x2'
se2pfe args (AppSE x1 x2) = do
    x1' <- se2pfe args x1
    x2' <- se2pfe args x2
    sn  <- makeSN (length args)
    return $ AppPFE (AppPFE (MessyPFE "SN" sn) x1') x2'
se2pfe args (LamSE n x) =
    se2pfe (args ++ [n]) x
se2pfe args (LetSE decs x) = do
    decs' <- sequence $ map (sd2pfd args) decs
    x'    <- se2pfe args x
    return $ LetPFE decs' x'
se2pfe args (SigSE x t) = do
    x' <- se2pfe args x
    addSignature (length args) x' t
se2pfe args (MessySE e) =
    constify args $ MessyPFE "???" e

constify :: [Name] -> PointFreeExp -> Q PointFreeExp
constify [] x = return x
constify args x = do
    cc <- makeConst args
    return $ AppPFE (MessyPFE "const" cc) x

extract :: [Name] -> Name -> Q PointFreeExp
extract argNs varN
    | varN `elem` argNs =
        return $ MessyPFE "extrN" $ makeExtract argNs varN
    | True = constify argNs $ VarPFE varN

makeExtract :: [Name] -> Name -> Exp
makeExtract argNs varN = LamE pats body where
    pats = map VarP argNs
    body = VarE varN

makeConst :: [Name] -> Q Exp
makeConst [] = [|id|]
makeConst argNs = do
    thN   <- newName "th"
    let
        lam  = LamE pats body
        pats = (VarP thN) : map VarP argNs
        body = VarE thN
    return lam

makeSN :: Int -> Q Exp
makeSN n = do
    fN <- newName "f"
    aN <- newName "a"
    argNs <- replicateM n $ newName "x"
    let
        lam  = LamE pats body
        pats = [VarP fN, VarP aN] ++ (map VarP argNs)
        f    = VarE fN
        a    = VarE aN
        args = map VarE argNs
        body = AppE (bindAllE f args) (bindAllE a args)
    return lam

addSignature :: Int -> PointFreeExp -> Type -> Q PointFreeExp
addSignature n x t = do
    con <- makeSigConstraint n t
    return $ AppPFE con x

makeSigConstraint :: Int -> Type -> Q PointFreeExp
makeSigConstraint n t = do
    argName <- newName "x"
    tm      <- [|typeMatch|]
    u       <- [|undefined|]
    let
        con  = LamE [VarP argName] body
        arg  = VarE argName
        u1   = SigE u t
        u2   = bindAllE arg $ replicate n u
        body = bindAllE tm [arg, u1, u2]
    return $ MessyPFE "type" con

typeMatch :: a -> b -> b -> a
typeMatch x y z = x

simpDecToPointFreeDec :: SimpDec -> Q PointFreeDec
simpDecToPointFreeDec = sd2pfd []

sd2pfd :: [Name] -> SimpDec -> Q PointFreeDec
sd2pfd args (DecSD n x) = DecPFD n <$> x' where
    x' = se2pfe args x

pointFreeExpToExp :: PointFreeExp -> Exp
pointFreeExpToExp = pfe2e

pfe2e :: PointFreeExp -> Exp
pfe2e (VarPFE n) = VarE n
pfe2e (ConPFE n) = ConE n
pfe2e (LitPFE l) = LitE l
pfe2e (AppPFE x1 x2) = AppE x1' x2' where
    x1' = pfe2e x1
    x2' = pfe2e x2
pfe2e (LetPFE ds x) = LetE ds' x' where
    ds' = map pfd2d ds
    x'  = pfe2e x
pfe2e (MessyPFE s x) = x

pointFreeDecToDec :: PointFreeDec -> Dec
pointFreeDecToDec = pfd2d

pfd2d :: PointFreeDec -> Dec
pfd2d (DecPFD n x) = ValD (VarP n) body [] where
    body = NormalB x'
    x'   = pfe2e x

