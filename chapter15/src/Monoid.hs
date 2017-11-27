module Monoid where

import           Data.Monoid     hiding ((<>))
import           Data.Semigroup
import           Test.QuickCheck hiding (Failure, Success)

data Optional a
  = Nada
  | Only a
  deriving (Eq, Show)

instance Monoid a => Monoid (Optional a) where
  mempty = Nada
  mappend (Only x) (Only y) = Only (x `mappend` y)
  mappend (Only x) Nada     = Only x
  mappend Nada (Only y)     = Only y

monoidLeftIdentity :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty `mappend` a) == a

monoidRightIdentity :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a `mappend` mempty) == a

semiAssociativity :: (Eq m, Semigroup m) => m -> m -> m -> Bool
semiAssociativity x y z = x <> (y <> z) == (x <> y) <> z

newtype First' a = First'
  { getFirst' :: Optional a
  } deriving (Eq, Show)

instance Monoid (First' a) where
  mempty = First' Nada
  mappend (First' (Only x)) _ = First' (Only x)
  mappend _ (First' (Only x)) = First' (Only x)
  mappend _ _                 = First' Nada

newtype Identity a =
  Identity a
  deriving (Eq, Show)

instance Semigroup a => Semigroup (Identity a) where
  Identity x <> Identity y = Identity (x <> y)

instance (Semigroup a, Monoid a) => Monoid (Identity a) where
  mempty = Identity mempty
  mappend = (<>)

idGen :: (Arbitrary a) => Gen (Identity a)
idGen = do
  a <- arbitrary
  return $ Identity a

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = idGen

type IdentityString = Identity String

type IdentityAssoc = IdentityString -> IdentityString -> IdentityString -> Bool

data Two a b =
  Two a
      b
  deriving (Show, Eq)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  (Two a1 b1) <> (Two a2 b2) = Two (a1 <> a2) (b1 <> b2)

instance (Semigroup a, Monoid a, Semigroup b, Monoid b) =>
         Monoid (Two a b) where
  mempty = Two mempty mempty
  mappend = (<>)

twoGen :: (Arbitrary a, Arbitrary b) => Gen (Two a b)
twoGen = do
  a <- arbitrary
  b <- arbitrary
  return (Two a b)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = twoGen

type T = Two String String

type TwoAssoc = T -> T -> T -> Bool

tests :: IO ()
tests = do
  quickCheck (semiAssociativity :: IdentityAssoc)
  quickCheck (monoidLeftIdentity :: Identity String -> Bool)
  quickCheck (monoidRightIdentity :: Identity String -> Bool)
  quickCheck (semiAssociativity :: TwoAssoc)
  quickCheck (monoidLeftIdentity :: T -> Bool)
  quickCheck (monoidRightIdentity :: T -> Bool)
