
module Desimplify(
      simpExpToExp
    , simpDecToDec
) where

import Simple

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Monad
import Control.Applicative

simpExpToExp :: SimpExp -> Exp
simpExpToExp (VarSE n) = VarE n
simpExpToExp (ConSE n) = ConE n
simpExpToExp (LitSE l) = LitE l
simpExpToExp (AppSE x1 x2) =
    AppE (simpExpToExp x1) (simpExpToExp x2)
simpExpToExp (LamSE n x) =
    LamE [VarP n] (simpExpToExp x)
simpExpToExp (LetSE ds x) =
    LetE (simpDecToDec <$> ds) (simpExpToExp x)
simpExpToExp (SigSE x s) =
    SigE (simpExpToExp x) s
simpExpToExp (MessySE x) = x

simpDecToDec :: SimpDec -> Dec
simpDecToDec (DecSD n x) =
    ValD (VarP n) (NormalB x') [] where
        x' = simpExpToExp x

