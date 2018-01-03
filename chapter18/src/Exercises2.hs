module Exercises2 where

import Test.QuickCheck
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes
import Prelude hiding (Left, Right)

data Nope a =
  NopeDotJpg
  deriving (Eq, Show)

data MyEither b a
  = Left a
  | Right b
  deriving (Eq, Show)

instance Functor (MyEither b) where
  fmap _ (Right b) = Right b
  fmap f (Left a) = Left (f a)

instance (Monoid b) => Applicative (MyEither b) where
  pure = Left
  (Right a) <*> (Right a1) = Right (mappend a a1)
  (Left f) <*> (Left x) = Left (f x)
  (Left f) <*> (Right x) = Right x
  (Right f) <*> (Left x) = Right f

instance (Monoid b) => Monad (MyEither b) where
  return = pure
  (Left a) >>= f = f a
  (Right b) >>= _ = (Right b)

instance Functor Nope where
  fmap _ _ = NopeDotJpg

instance Applicative Nope where
  pure _ = NopeDotJpg
  _ <*> _ = NopeDotJpg

instance Monad Nope where
  return = pure
  NopeDotJpg >>= f = NopeDotJpg

instance Eq a => EqProp (Nope a) where
  (=-=) = eq

instance (Eq b, Eq a) => EqProp (MyEither b a) where
  (=-=) = eq

instance Arbitrary a => Arbitrary (Nope a) where
  arbitrary = return NopeDotJpg

instance (Arbitrary a, Arbitrary b) => Arbitrary (MyEither b a) where
  arbitrary = genEither

genEither :: (Arbitrary a, Arbitrary b) => Gen (MyEither b a)
genEither = do
  b <- arbitrary
  a <- arbitrary
  elements [Left a, Right b]

testEither = do
  let trigger = undefined :: MyEither String (Int, String, Int)
  quickBatch $ functor trigger
  quickBatch $ applicative trigger
  quickBatch $ monad trigger

testNope = do
  let trigger = undefined :: Nope (Int, String, Int)
  quickBatch $ functor trigger
  quickBatch $ applicative trigger
  quickBatch $ monad trigger
