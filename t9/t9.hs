
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TypeSynonymInstances #-}

import Data.Char (toLower, isAlpha)
import Data.List (foldl', groupBy, sort)
import System.IO (withFile, IOMode(..), hGetChar, hGetLine, hSetBinaryMode)
import System.IO.Error (IOError, isEOFError)
import Grouping

split p [] = []
split p (c:cs) =
    if p c
       then [] : (split p cs)
       else case (split p cs) of
                 [] -> [[c]]
                 g:gs -> (c:g) : gs

slurpLines file = do
        flip catch handle $ do
            x <- hGetLine file
            xs <- slurpLines file
            return (x : xs)
    where
        handle e =
            if isEOFError e
               then return []
               else ioError e

foreach ls f = sequence_ $ map' ls f

cleanWord :: String -> String
cleanWord s = map toLower s

data Key = K1 | K2 | K3 | K4 | K5 | K6 | K7 | K8 | K9 | K0
    deriving (Eq,Ord)

instance Show Key where
    show k = case k of
                  K1 -> "1" ; K2 -> "2" ; K3 -> "3"
                  K4 -> "4" ; K5 -> "5" ; K6 -> "6"
                  K7 -> "7" ; K8 -> "8" ; K9 -> "9"
                  K0 -> "0"
    
data KeySeq = KeySeq [Key]
    deriving (Eq,Ord)

instance Show KeySeq where
    show (KeySeq ks) = foldl' (++) "" (map show ks)

letterKey :: Char -> Key
letterKey c =
    if not (isAlpha c)
       then K1
       else if (c == ' ')
           then K0
           else case c of
                 'a' -> K2 ; 'b' -> K2 ; 'c' -> K2
                 'd' -> K3 ; 'e' -> K3 ; 'f' -> K3
                 'g' -> K4 ; 'h' -> K4 ; 'i' -> K4
                 'j' -> K5 ; 'k' -> K5 ; 'l' -> K5
                 'm' -> K6 ; 'n' -> K6 ; 'o' -> K6
                 'p' -> K7 ; 'q' -> K7 ; 'r' -> K7 ; 's' -> K7
                 't' -> K8 ; 'u' -> K8 ; 'v' -> K8
                 'w' -> K9 ; 'x' -> K9 ; 'y' -> K9 ; 'z' -> K9
                 _ -> K1

seqOfWord w = KeySeq (map letterKey $ cleanWord w)

data KeyedWord = KeyedWord {
        kwWord :: String,
        kwKey  :: KeySeq
    }
    deriving (Show, Eq, Ord)
    
instance KVPair KeyedWord KeySeq String where
    kvKey = kwKey
    kvValue = kwWord
    
keyWord w = KeyedWord w (seqOfWord w)

data KeyGroup = KeyGroup KeySeq [String]
    deriving (Eq)

instance Ord KeyGroup where
    compare a b = compare (groupSize a) (groupSize b)

groupSize (KeyGroup _ w) = length w

makeKeyGroups words = sort $ map' groups (\(k,w) -> KeyGroup k w)
    where
        groups = groupsOf kw
        kw = map keyWord words

printGroup (KeyGroup key words) = do
    putStrLn ((show key) ++ ":")
    foreach words $ \word ->
        putStrLn ("    " ++ word)
        
readWords = do
    withFile "./englishwords.list" ReadMode $ \hl -> do
        hSetBinaryMode hl True
        putStrLn "Reading..."
        lines <- slurpLines hl
        putStrLn "Read"
        return lines

main = do
    allWords <- readWords
    foreach (makeKeyGroups allWords) $ \group ->
        if groupSize group > 1
            then printGroup group
            else return ()

