module Monoidal where

import Data.Monoid

data Optional a
  = Nada
  | Only a
  deriving (Eq, Show)

instance Monoid a => Monoid (Optional a) where
  mempty = Nada
  mappend (Only x) (Only y) = Only (x <> y)
  mappend (Only x) Nada = Only x
  mappend Nada (Only y) = Only y

monoidLeftIdentity :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

monoidAssociativity :: (Eq m, Monoid m) => m -> m -> m -> Bool
monoidAssociativity x y z =
  x <> (y <> z) == (x <> y) <> z

newtype First' a =
  First' { getFirst' :: Optional a }
  deriving (Eq, Show)

instance Monoid (First' a) where
  mempty = First' Nada
  mappend (First' (Only x)) _ = First' (Only x)
  mappend _ (First' (Only x)) = First' (Only x)
  mappend _ _ = First' Nada

newtype Shortest a =
  Shortest [a]
  deriving (Eq, Show)

instance Monoid (Shortest a) where
  mempty = Shortest []
  mappend (Shortest a) (Shortest b)
    | length a > length b = Shortest b
    | length a < length b = Shortest a
    | otherwise = Shortest a

