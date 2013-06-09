
import Maybe 

data ColumnFlavor t = ColumnFlavor

data CSVColumnFlavor a = CSVColumnFlavor {
    flavor :: ColumnFlavor a,
    reader :: String -> Maybe a
}

tInt    = ColumnFlavor :: ColumnFlavor Int
tString = ColumnFlavor :: ColumnFlavor String
tDouble = ColumnFlavor :: ColumnFlavor Double

csvInt    = CSVColumnFlavor tInt    maybeRead
csvString = CSVColumnFlavor tString Just
csvDouble = CSVColumnFlavor tDouble maybeRead

maybeRead :: (Read a) => String -> Maybe a
maybeRead = (fmap fst) . listToMaybe . reads

