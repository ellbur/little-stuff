
module CSV where

-- Look at http://book.realworldhaskell.org/read/using-parsec.html

import Text.ParserCombinators.Parsec

data CSV = CSV [String] [[String]]
	deriving (Show)

csvFile = do
	header <- line
	lines  <- many line
	eof
	return (CSV header lines)

line = do
	cells <- cells
	eol
	return cells

cells = do
	first <- cell
	rest  <- remainingCells
	return (first : rest)

cell = do
	many (noneOf ",\n")

remainingCells = do
	(char ',' >> cells) <|> (return [])

eol = char '\n'

parseCSV :: String -> Either ParseError CSV
parseCSV text = parse csvFile "???" text

