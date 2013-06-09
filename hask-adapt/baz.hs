
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE EmptyDataDecls #-}

data VarA
data VarB

data DynVar l t = DynVar l

class AsDynExp a b | a -> b where
    asDynExp :: a -> b

instance (Normal t) => AsDynExp t t where
    asDynExp x = x

instance AsDynExp Int Char where
    asDynExp x = 'c'

class Normal t

instance Normal Bool

main = do
    print "hi"
    print (asDynExp (5::Int))

