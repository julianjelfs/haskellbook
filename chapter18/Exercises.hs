module Exercises where

data Sum a b
  = First a
  | Second b
  deriving (Eq, Show)

instance Functor (Sum a) where
  fmap f (First a) = First a
  fmap f (Second b) = Second (f b)

instance Monoid a => Applicative (Sum a) where
  pure = Second
  First e <*> First e' = First (mappend e e')
  First e <*> Second _ = First e
  Second f <*> Second a = Second (f a)
  Second _ <*> First e = First e

instance Monoid a => Monad (Sum a) where
  return = pure
  First e >>= _ = First e
  Second a >>= f = f a
