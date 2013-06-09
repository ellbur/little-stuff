
module PointFree where

import Language.Haskell.TH

data PointFreeExp =
      VarPFE Name
    | ConPFE Name
    | LitPFE Lit
    | AppPFE PointFreeExp PointFreeExp
    | LetPFE [PointFreeDec] PointFreeExp
    | MessyPFE String Exp
    deriving (Eq)

data PointFreeDec =
    DecPFD Name PointFreeExp
    deriving (Show,Eq)

instance Show PointFreeExp where
    show = showPFE

showPFE :: PointFreeExp -> String
showPFE (VarPFE n) = show n
showPFE (ConPFE n) = show n
showPFE (LitPFE l) = pprint (LitE l)
showPFE (AppPFE x1 x2) =
    "(" ++ (show x1) ++ " " ++ (show x2) ++ ")"
showPFE (LetPFE decs x) =
    "let " ++ (foldr (++) "" (map show decs)) ++ " in " ++ (show x)
showPFE (MessyPFE d x) = d

