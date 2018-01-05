module Exercises2 where

import Prelude hiding (Left, Right)
import Test.QuickCheck
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes
import Control.Monad (join)

data List a =
  Nil
  | Cons a (List a)
  deriving (Eq, Show)

instance Monoid (List a) where
  mempty = Nil
  mappend Nil l = l
  mappend l Nil = l
  mappend (Cons x xs) b = Cons x (mappend xs b)

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons x xs) = Cons (f x) (fmap f xs)

instance Applicative List where
  pure x = Cons x Nil
  (Cons f fs) <*> xs = mappend (fmap f xs) (fs <*> xs)
  _ <*> _ = Nil

instance Monad List where
  return = pure
  Nil >>= f = Nil
  (Cons x xs) >>= f = mappend (f x) (xs >>= f)

newtype Identity a = Identity a
  deriving (Eq, Ord, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity (f a)

instance Applicative Identity where
  pure = Identity
  (Identity f) <*> (Identity x) = Identity (f x)

instance Monad Identity where
  return = pure
  (Identity x) >>= f = f x

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

instance Eq a => EqProp (Identity a) where
  (=-=) = eq

instance Eq a => EqProp (List a) where
  (=-=) = eq

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = Identity <$> arbitrary

instance Arbitrary a => Arbitrary (Nope a) where
  arbitrary = return NopeDotJpg

instance (Arbitrary a, Arbitrary b) => Arbitrary (MyEither b a) where
  arbitrary = genEither

genEither :: (Arbitrary a, Arbitrary b) => Gen (MyEither b a)
genEither = do
  b <- arbitrary
  a <- arbitrary
  elements [Left a, Right b]

instance Arbitrary a => Arbitrary (List a) where
  arbitrary = genList

genList :: Arbitrary a => Gen (List a)
genList = do
  h <- arbitrary
  t <- genList
  frequency [(3, return $ Cons h t),
             (1, return Nil)]


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

testIdentity = do
  let trigger = undefined :: Identity (Int, String, Int)
  quickBatch $ functor trigger
  quickBatch $ applicative trigger
  quickBatch $ monad trigger

testList = do
  let trigger = undefined :: List (Int, String, Int)
  quickBatch $ functor trigger
  quickBatch $ applicative trigger
  quickBatch $ monad trigger

--j :: [[]] -> []
--j :: Maybe (Maybe a) -> Maybe a
j :: Monad m => m (m a) -> m a
j m = m >>= id

l1 :: Monad m => (a -> b) -> m a -> m b
l1 f x = f <$> x

l2 :: Monad m => (a -> b -> c) -> m a -> m b -> m c
l2 f x y = f <$> x <*> y

a :: Monad m => m a -> m (a -> b) -> m b
a x y = y <*> x

--couldn't have arrived at this one on my own I don't think
meh :: Monad m => [a] -> (a -> m b) -> m [b]
meh [] _ = return []
meh (x:xs) f = do
  x' <- (f x)
  fmap ((:) x') (meh xs f)

flipType :: Monad m => [m a] -> m [a]
flipType xs = (flip meh) id xs
