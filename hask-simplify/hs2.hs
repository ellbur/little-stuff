
{-# LANGUAGE TemplateHaskell #-}

import Simple
import Simplify
import Desimplify
import PointFree
import PointFreeify
import Transforms

import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.Meta.Parse

import Control.Monad
import Control.Applicative

t1 = [| 2 |]
t2 = [| \x -> 2 |]
t3 = [| \x -> x |]
t4 = [| \x -> x + 2 |]
t5 = [| if True then 3 else 4 |]
t6 = [| \x y -> x |]
t7 = [| \x -> (2::Int) |]

e1 = $(pf [| 2 |])
e2 = $(pf [| \x -> 2 |])
e3 = $(pf [| \x -> x |])
e4 = $(pf [| \x -> x + 2 |])
e5 = $(pf [| if True then 3 else 4 |])
e6 = $(pf [| \x y -> x |])
e7 = $(pf [| \x -> (2::Int) |])

e8 = $(pf [|
        let x = 1
            y = x : y :: [Int]
        in
            y !! 10
    |])

e9 = $(pf [|
        let x = 1
            y = x : ((1+) <$> y)
        in
            sum $ (y !!) <$> [0..10]
    |])

pp :: (Ppr a) => Q a -> IO ()
pp x = (putStrLn =<<) $ runQ $ fmap pprint $ x

pe :: String -> Exp
pe str = case parseExp str of
              Right x -> x

pd :: String -> Dec
pd str = case parseDecs str of
              Right (dec:decs) -> dec

main = do
    print "hi"


