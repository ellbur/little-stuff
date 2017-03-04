
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

import Prelude hiding ((.))

class Member c f where
    type T
    get :: c -> f -> T
    
data Foo = Foo Int Int

data X = X
instance Member Foo X where
    type T = Int
    get (Foo x _) X = x

main = do
    let f = Foo 1 2
    print $ f `get` X

