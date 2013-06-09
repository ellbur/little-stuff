
module eday where

open import System.IO
open import Data.String renaming (_++_ to _cat_)
open import Data.Integer
open import Data.Char
open import Data.Bool
open import Data.List
open import Data.Maybe

data DayOfWeek : Set where
    Sunday    : DayOfWeek
    Monday    : DayOfWeek
    Tuesday   : DayOfWeek
    Wednesday : DayOfWeek
    Thursday  : DayOfWeek
    Friday    : DayOfWeek
    Saturday  : DayOfWeek

electionDay : DayOfWeek → ℤ
electionDay Sunday    = + 3
electionDay Monday    = + 2
electionDay Tuesday   = + 8
electionDay Wednesday = + 7
electionDay Thursday  = + 6
electionDay Friday    = + 5
electionDay Saturday  = + 4

parseDay : String → (Maybe DayOfWeek)
parseDay "su" = just Sunday
parseDay "m"  = just Monday
parseDay "t"  = just Tuesday
parseDay "w"  = just Wednesday
parseDay "th" = just Thursday
parseDay "f"  = just Friday
parseDay "s"  = just Saturday
parseDay other = nothing

space : Char -> Bool
space ' '  = true
space '\n' = true
space '\t' = true
space x    = false

tailTrim' : (List Char) → (List Char)
tailTrim' [] = []
tailTrim' (car ∷ cdr) =
    if (space car) ∧ (null cdr)
        then []
        else car ∷ (tailTrim' cdr)

tailTrim : String → String
tailTrim x = fromList (tailTrim' (toList x))

trim' : (List Char) → (List Char)
trim' [] = []
trim' (car ∷ cdr) =
    if space car
       then trim' cdr
       else car ∷ (tailTrim' cdr)

trim : String → String
trim x = fromList (trim' (toList x))

doDay : String → (Maybe DayOfWeek) → String
doDay x (just day) = show (electionDay day)
doDay x nothing    = ("Sorry, don't recognize " cat x)

main : IO Unit
main = 
       putStr "Day: "
    >> commit
    >> getStr >>= λ dayStr
    -> let dayTrim : String
           dayTrim = trim dayStr
    in let day : (Maybe DayOfWeek)
           day = parseDay dayTrim
    in putStr (doDay dayTrim day)
    >> putStr "\n"
    >> commit


