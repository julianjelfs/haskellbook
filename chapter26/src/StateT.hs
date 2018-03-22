module StateT where

newtype StateT s m a =
    StateT { runStateT :: s -> m (a, s) }

-- f :: a -> b
-- fmap :: (a -> b) -> (StateT sma) -> (StateT smb)
instance Functor m => Functor (StateT s m) where
  fmap f (StateT sma) = StateT $ \s -> (\(a, s') -> (f a, s')) <$> (sma s)

--instance (Applicative m) => Applicative (StateT s m) where
--  pure a = StateT (pure (pure a))
--
--  (StateT fmab) <*> (StateT sma) =
--    StateT $ (<*>) <$> fmab <*> sma
--
--instance (Monad m) => Monad (StateT r m) where
--  return = pure
--
--  (StateT sma) >>= f =
--    StateT $ \s -> do
--      a <- sma s
--      runStateT (f a) r
