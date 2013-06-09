
{-# LANGUAGE TemplateHaskell #-}

import Simple
import Simplify
import Desimplify
import Transforms

import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.Meta.Parse

import Control.Monad
import Control.Applicative

x = 5 :: Int
y = 7 :: Int

e1 = $(p [|x|])
e2 = $(p [|x + y|])
e3 = $(p [|
        if x > y then x else y
    |])
e4 = $(p [|
        case x of
             a -> "yo"
    |])
e5 = $(p [|
        case (x, y) of
             (5, b) -> (b, b)
    |])

e6 = $(p [|
        let
            (a, b)
                | True  = (5, 5)
                | False = (6, 6)
        in
            a + b
    |])

e7 = $(p [|
        (\(a,b) -> a + b)
            (2, 3)
    |])

e8 = $(p [|
        do
            a <- [1, 2]
            b <- [1, 2]
            let
                c = a + a
                d = a + b
            return $ c + d
    |])

e8' = do
    a <- [1, 2]
    b <- [1, 2]
    let
        c = a + a
        d = a + b
    return $ c + d

e9 = $(p [|
        [a | a <- ['a','b']]
    |])

e10 = $(p [|
        sum [0,1..10]
    |])

data ARec = ARec {
        arec_a :: Int
    }
    deriving (Show,Eq)

e11 = $(p [|
        ARec { arec_a = 10 }
    |])

e12 = $(p [|
        let
            a = ARec { arec_a = 10 }
            b = a { arec_a = 11 }
        in
            b
    |])

pp :: (Ppr a) => Q a -> IO ()
pp x = (putStrLn =<<) $ runQ $ fmap pprint $ x

pe :: String -> Exp
pe str = case parseExp str of
              Right x -> x

pd :: String -> Dec
pd str = case parseDecs str of
              Right (dec:decs) -> dec

pvd :: String -> (Pat, Body)
pvd str = case parseDecs str of
               Right ((ValD pat body _):_) -> (pat, body)

main = do
    print "hi"

