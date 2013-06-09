
module nums where

postulate Integer : Set
{-# COMPILED_TYPE Integer Integer #-}
postulate h0 : Integer
{-# COMPILED h0 (0::Integer) #-}
postulate h1 : Integer
{-# COMPILED h0 (1::Integer) #-}

infixl 20 _+_
postulate _+_ : Integer -> Integer -> Integer
{-# COMPILED _+_ ((+)::Integer->Integer->Integer) #-}

postulate String : Set
postulate ---------------------------------

postulate showInteger :

