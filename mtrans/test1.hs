
{-# LANGUAGE FlexibleContexts #-}

import Control.Monad
import Control.Monad.Identity

newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }

instance (Show a) => Show (Identity a) where
    show = show . runIdentity

instance (Monad m) => Monad (MaybeT m) where
    --return :: a -> MaybeT m a
    return a =
        MaybeT $ return $ Just a
    
    --(>>=) :: MaybeT m a -> (a -> MaybeT m b) -> MaybeT m b
    (>>=) x f = MaybeT $ do
        a' <- runMaybeT x
        case a' of
             Nothing -> return Nothing
             Just a  -> runMaybeT $ f a

main = do
    print $ runMaybeT run

run :: MaybeT Identity Int
run = do
    x <- MaybeT $ Identity $ Just 5
    y <- MaybeT $ Identity $ Nothing
    return x

