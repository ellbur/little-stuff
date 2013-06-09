
module Simple where

import Language.Haskell.TH

data SimpExp =
      VarSE Name
    | ConSE Name
    | LitSE Lit
    | AppSE SimpExp SimpExp
    | LamSE Name SimpExp
    | LetSE [SimpDec] SimpExp
    | SigSE SimpExp Type
    | MessySE Exp
    deriving (Show,Eq)

data SimpDec = DecSD Name SimpExp
    deriving (Show,Eq)


