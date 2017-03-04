
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

import Prelude hiding ((.))

class Member c f t | c f -> t where
    get :: c -> f -> t
    
infixl 9 .
a . b = a `get` b

data Foo = Foo Int Int

data X = X
instance Member Foo X Int where
    get (Foo x _) X = x

data Y = Y
instance Member Foo Y Int where
    get (Foo _ y) Y = y

data In = In
instance Member Foo In (Int -> Bool) where
    get (Foo x y) In z = (x <= z) && (z <= y)
    
-- Let the mmr do its work
fooAdd = \f -> (f `get` X) + (f `get` Y)

addSum f1 f2 = (fooAdd f1) + (fooAdd f2)

main = do
    let f = Foo 1 2
    print $ f.X
    print $ f.Y
    print $ fooAdd f
    print $ (f.In) 3 -- Parens needed

