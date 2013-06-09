
import Data.Set as Set

data Idiom = Idiom { i_name :: String, i_pure :: Object, i_ap :: Object, i_bind :: Object }

instance Eq Idiom where
    a == b = (i_name a) == (i_name b)
    
instance Ord Idiom where
    compare a b = compare (i_name a) (i_name b)
    
instance Show Idiom where
    show a = i_name a

data Object = Object (Object -> [Idiom] -> Object) (Set Idiom)

instance Show Object where
    show o = "o"

oI = Object (\arg is -> arg) empty

oK = Object (\a is1 -> Object (\b is2 -> a) empty) empty

m :: Object -> Object -> Object
m (Object car carIdioms) cdr =
    if Set.null carIdioms
       then Object (
       else undefined



