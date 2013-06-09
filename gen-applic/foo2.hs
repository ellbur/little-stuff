
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

class Op f where
    op :: a -> f a

instance Op [] where
    op x = [x]

foo :: [[Int]]
foo = op $ op 1

main = do
    print $ foo

