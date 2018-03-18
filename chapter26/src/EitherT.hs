module EitherT where

newtype EitherT e m a =
    EitherT { runEitherT :: m (Either e a) }

instance Functor m => Functor (EitherT e m) where
  fmap = undefined

instance Applicative m => Applicative (EitherT e m) where
  pure = undefined

  f <*> a = undefined

instance Monad m => Monad (EitherT e m) where
  return = pure

  v >>= f = undefined

    

