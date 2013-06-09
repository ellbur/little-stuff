
{-# LANGUAGE TypeSynonymInstances #-}

module Table where

import CSV
import Maybe

-- See http://stackoverflow.com/questions/5024148/
--   how-to-iterate-through-a-heterogeneous-recursive-value-in-haskell
-- for the general technique.

maybeRead :: (Read a) => String -> Maybe a
maybeRead = fmap fst . listToMaybe . reads

class TableRead a where
	tableRead :: String -> Maybe a

instance TableRead Int where
	tableRead = maybeRead

instance TableRead String where
	tableRead = Just

data Table a b = Table [String] (ColList a b)
	deriving (Show)

data ColList a b = ColListPair [a] b
	deriving (Show)
colListNil = ()

class AddToColList a where
	addToColList :: a -> [String] -> Maybe a

addToColListNil :: () -> [String] -> Maybe ()
addToColListNil () [] = Just ()
addToColListNil x y = Nothing

instance AddToColList () where
	addToColList = addToColListNil

addToColListPair :: (TableRead a, AddToColList b) =>
	ColList a b -> [String] -> Maybe (ColList a b)
addToColListPair (ColListPair xs rest) (str : strs) = do
	parsed <- tableRead str
	addedRest <- addToColList rest strs
	return (ColListPair (parsed : xs) addedRest)
addToColListPair x y = Nothing

instance (TableRead a, AddToColList b) => AddToColList (ColList a b) where
	addToColList = addToColListPair 

class BlankColList a where
	blankColList :: a

blankColListNil :: ()
blankColListNil = ()

instance BlankColList () where
	blankColList = blankColListNil

blankColListPair :: (BlankColList b) => ColList a b
blankColListPair = ColListPair [] blankColList

instance (BlankColList b) => BlankColList (ColList a b) where
    blankColList = blankColListPair
	
tableFromCSV (CSV header csvRows) = do
	colList <- buildColList csvRows
	return (Table header colList)

buildColList (csvRow : csvRows) = do
	partList <- buildColList csvRows
	fullList <- addToColList partList csvRow
	return fullList
buildColList [] = Just blankColList

