
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}

module StrType where

import Language.Haskell.TH
import Data.Typeable

data LabelNil deriving (Typeable)
data LabelCons x y deriving (Typeable)

l = stringLabel'

stringLabel' :: String -> Q Exp
stringLabel' = return . stringLabel

stringLabel :: String -> Exp
stringLabel str = SigE (VarE (mkName "proxy")) ptype where
    ptype = AppT pcon (stringType str)
    pcon = ConT (mkName "Proxy")

stringType' :: String -> Q Type
stringType' = return . stringType

stringType :: String -> Type
stringType [] = ConT (mkName "LabelNil")
stringType (l : ls) = AppT
    (AppT (ConT (mkName "LabelCons")) (letterType l))
    (stringType ls)

letterType :: Char -> Type
letterType c = ConT (mkName $ "Label" ++ [c])

defineLetterLabels' :: [Char] -> Q [Dec]
defineLetterLabels' = return . defineLetterLabels

defineLetterLabels :: [Char] -> [Dec]
defineLetterLabels chars = map defineLetterLabel chars

defineLetterLabel :: Char -> Dec
defineLetterLabel ch = DataD [] name [] [] der where
    name = (mkName $ "Label" ++ [ch])
    der  = [mkName "Typeable"]

