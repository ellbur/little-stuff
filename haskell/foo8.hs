
{-# LANGUAGE DisambiguateRecordFields #-}

module Main where

import System.Console.GetOpt
import Data.Maybe

-- http://www.haskell.org/ghc/docs/latest/html/libraries/base/System-Console-GetOpt.html

data Options = Options
    { optHelp :: Bool
    }

defaultOptions = Options
    { optHelp = False
    }

options :: [OptDescr (Options -> Options)]
options =
    [ Option [] ["help"]
        (NoArg (\o -> o { optHelp = True }))
        "Show the help message"
    ]

parseOpts :: [String] -> Maybe (Options, [String])

