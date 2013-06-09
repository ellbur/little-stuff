
import Table
import CSV
import Text.ParserCombinators.Parsec

main = do
    text <- readFile "foo.csv"
    let csv = parseCSV text
    print csv
    eitherSwitch csv
        print    
        (print . myTable)

type MyTableType = Table Int (ColList Int ())
    
myTable :: CSV -> Maybe MyTableType
myTable = tableFromCSV
    
eitherSwitch (Left x)  f g = f x
eitherSwitch (Right x) f g = g x

