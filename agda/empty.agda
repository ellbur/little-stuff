
module empty where

module genapplic where

data List (A : Set) : Set where
    [] : List A
    _∷_ : A -> List A -> List A

infixl 10 _++_
_++_ : {A : Set} -> List A -> List A -> List A
_++_ [] b = b
_++_ (x ∷ xs) b = x ∷ (xs ++ b)

data ListNotEmpty {A : Set} : List A -> Set where
    hasHead : (x : A) -> (xs : List A) -> ListNotEmpty (x ∷ xs)

prop1 : {A : Set} -> (x : A) -> (xs : List A) -> ListNotEmpty (x ∷ xs)
prop1 = hasHead

data StartsWith {A : Set} : List A -> List A -> Set where
    done : (ys : List A) -> StartsWith [] ys
    oneMore : (x : A) -> (xs : List A) -> (ys : List A) ->
        StartsWith xs ys -> StartsWith (x ∷ xs) (x ∷ ys)

prop2 : {A : Set} -> (xs : List A) -> (ys : List A) -> StartsWith xs (xs ++ ys)
prop2 [] b = done b
prop2 (x ∷ xs) b = oneMore x xs (xs ++ b) (prop2 xs b)

prop3 : {A : Set} (xs : List A) (ys : List A) -> StartsWith xs ys -> ListNotEmpty xs -> ListNotEmpty ys
prop3 _ _ _ _ = _

--prop4 : {A : Set} -> (xs : List A) -> (ys : List A) ->
--    ListNotEmpty xs -> ListNotEmpty (xs ++ ys)
--prop4 = _

