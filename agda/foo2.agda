
module foo2 where

data Choice : Set where
    A B C : Choice

module hidden where
    data Foo : Set where
        x : Choice -> Foo

open hidden

data Bar : Set where
    x : Choice -> Bar

this = x A

