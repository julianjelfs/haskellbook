module Exercises where

import Data.List (elemIndex)
import Control.Applicative

added :: Maybe Integer
added = (+3) <$> (lookup 3 $ zip [1,2,3] [4,5,6])

y :: Maybe Integer
y = lookup 3 $ zip [1,2,3] [4,5,6]

z :: Maybe Integer
z = lookup 2 $ zip [1,2,3] [4,5,6]

tupled :: Maybe (Integer, Integer)
tupled = (,) <$> y <*> z

a :: Maybe Int
a = elemIndex 3 [1..5]

b :: Maybe Int
b = elemIndex 4 [1..5]

max' :: Int -> Int -> Int
max' = max

maxed :: Maybe Int
maxed = max' <$> a <*> b

summed :: Maybe Integer
summed = undefined  -- not sure what to do with this one

newtype Identity a = Identity a
  deriving (Eq, Ord, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity (f a)

instance Applicative Identity where
  pure a = Identity a
  (Identity f) <*> (Identity a) = Identity (f a)

newtype Constant a b =
  Constant { getConstant :: a }
  deriving (Eq, Ord, Show)

instance Functor (Constant a) where
  fmap f (Constant a) = Constant a

instance Monoid a => Applicative (Constant a) where
  pure b = Constant mempty
  (Constant f) <*> (Constant b) = Constant b

data Two a b = Two a b deriving Show

instance Functor (Two a) where
  fmap f (Two m a) = Two m (f a)

instance Monoid a => Applicative (Two a) where
  pure = Two mempty
  (Two m f) <*> (Two m' x) = Two (mappend m m') (f x)

data Three a b c = Three a b c deriving Show

instance Functor (Three a b) where
  fmap f (Three m n a) = Three m n (f a)

instance (Monoid a, Monoid b) => Applicative (Three a b) where
  pure = Three mempty mempty
  (Three m n f) <*> (Three m' n' a) = Three (mappend m m') (mappend n n') (f a)

combos :: [a] -> [b] -> [c] -> [(a,b,c)]
combos as bs cs =
  (,,) <$> as <*> bs <*> cs
