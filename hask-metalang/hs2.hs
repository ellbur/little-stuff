
{-# LANGUAGE TemplateHaskell #-}

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import MetaLang
import MaybeLang
import Simplify
import PointFreeify
import Desimplify

pp :: (Ppr a) => Q a -> IO ()
pp x = (putStrLn =<<) $ runQ $ fmap pprint $ x

e1 = $(maybeLang [|1|])
e2 = $(maybeLang [|
        1 + 2
    |])
e3 = $(maybeLang [|
        (nd Nothing) + 2
    |])

e4 = $(maybeLang [|
        let x = 3
        in
            x + 5
    |])

e5 = $(maybeLang [|
        let x = (nd Nothing)
        in
            x + 5
    |])

main = do
    print e1
    print e2
    print e3
    print e4
    print e5


