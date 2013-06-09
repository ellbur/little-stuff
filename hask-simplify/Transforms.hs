
module Transforms where

import Simple
import Simplify
import Desimplify
import PointFreeify

import Language.Haskell.TH
import Language.Haskell.TH.Quote

p = (se =<<)

se :: Exp -> Q Exp
se x = fmap simpExpToExp (expToSimpExp x)

sd :: Dec -> Q [Dec]
sd d = fmap (map simpDecToDec) (decToSimpDecs d)

pf :: Q Exp -> Q Exp
pf x = fmap pointFreeExpToExp $
    simpExpToPointFreeExp =<< expToSimpExp =<< x


