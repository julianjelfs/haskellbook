module EitherT where

newtype EitherT e m a =
    EitherT { runEitherT :: m (Either e a) }

instance Functor m => Functor (EitherT e m) where
  fmap f (EitherT me) = EitherT $ (fmap . fmap) f me

instance Applicative m => Applicative (EitherT e m) where
  pure x = EitherT (pure (pure x))
  (EitherT fe) <*> (EitherT me) = EitherT $ (<*>) <$> fe <*> me

instance Monad m => Monad (EitherT e m) where
  return = pure
  (EitherT me) >>= f =
    EitherT $ do
      v <- me
      case v of
        Left err -> return (Left err)
        Right ok -> runEitherT (f ok)


swapEitherT :: (Functor m) => EitherT e m a -> EitherT a m e
swapEitherT (EitherT me) = EitherT $ fmap swapEither me

swapEither :: Either e a -> Either a e
swapEither (Left e) = Right e
swapEither (Right a) = Left a

    

