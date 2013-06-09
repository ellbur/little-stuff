
module ExpUtils where

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Monad
import Control.Applicative

bindAllE :: Exp -> [Exp] -> Exp
bindAllE f [] = f
bindAllE f (x : xs) = bindAllE (AppE f x) xs

expName :: Exp -> Name
expName (VarE n) = n

