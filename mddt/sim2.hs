
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE RecordWildCards #-}

import GSL.Random.Gen
import GSL.Random.Dist
import Control.Applicative
import Control.Monad
import System.Time
import Data.Word

data ScanState = ScanState {
        nCounts :: Int,
        ok      :: Bool,
        ltSoFar :: Double
    }
    deriving Show

initScanState shapingTime icr rng = do
    delta <- getExponential rng (1.0/icr)
    let initOK = delta >= shapingTime/2.0
    return $ ScanState {
            nCounts = 0,
            ok      = initOK,
            ltSoFar = 0.0
        }

nextScanState shapingTime targetLT icr rng (ScanState {..}) = do
    delta <- getExponential rng (1.0/icr)
    return $
        let 
            nextLTSoFar = ltSoFar + delta
            nextOK      = delta >= shapingTime/2.0
            nextNCounts =
                if ok && nextOK
                   then nCounts + 1
                   else nCounts
        in
        if nextLTSoFar >= targetLT
           then Nothing
           else Just $ ScanState {
                   nCounts = nextNCounts,
                   ok      = nextOK,
                   ltSoFar = nextLTSoFar
               }

runScan shapingTime targetLT icr rng = do
    let go state = do
        next <- nextScanState shapingTime targetLT icr rng state
        case next of
             Nothing   -> return (fromIntegral c/targetLT) where ScanState { nCounts = c } = state
             Just next -> go next
    go =<< initScanState shapingTime icr rng

runScans shapingTime targetLT icr rng n =
    replicateM n $ runScan shapingTime targetLT icr rng

mean ls = sum ls / (fromIntegral $ length ls)
sd ls = sqrt $ sum [(x - m)**2 | x <- ls] / (n - 1)
    where m = mean ls
          n = fromIntegral $ length ls

zInt ls =
    let
        m  = mean ls
        s  = sd ls
        hw = s * 1.96 / (sqrt n)
        n  = fromIntegral $ length ls
    in
        (m - hw, m + hw)

main = do
    let shapingTime = 1.0e-6
    let icr         = 500.0e3
    let targetLT    = shapingTime * 10
    rng <- newRNG mt19937
    TOD sec psec <- getClockTime
    let seed = (fromInteger sec) + (fromInteger psec)
    setSeed rng seed
    print =<< zInt <$> (runScans shapingTime targetLT icr rng 20000)
    
