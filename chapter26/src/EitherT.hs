module EitherT where

newtype EitherT e m a =
    EitherT { runEitherT :: m (Either e a) }

instance Functor m => Functor (EitherT e m) where
  fmap f (EitherT me) = EitherT $ (fmap . fmap) f me

instance Applicative m => Applicative (EitherT e m) where
  pure = undefined

  f <*> a = undefined

instance Monad m => Monad (EitherT e m) where
  return = pure

  v >>= f = undefined


swapEitherT :: (Functor m) => EitherT e m a -> EitherT a m e
swapEitherT = undefined

swapEither :: Either e a -> Either a e
swapEither (Left e) = Right e
swapEither (Right a) = Left a

    

