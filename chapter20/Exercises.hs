module Exercises where

import Data.Monoid

sum :: (Foldable t, Num a) => t a -> a
sum f = getSum $ foldMap Sum f

product :: (Foldable t, Num a) => t a -> a
product f = getProduct $ foldMap Product f

elem :: (Foldable t, Eq a) => a -> t a -> Bool
elem x f = getAny $ foldMap (Any . (== x)) f

--could also implement minimum and maximum by creating monoid instances of a Num wrapper and using foldMap
--but it ends up being a lot more code
minimum :: (Foldable t, Ord a) => t a -> Maybe a
minimum f = foldr (\a b -> Just $ maybe a (\b -> min a b) b) Nothing f

--this causes a stack overflow. Not sure why.
--so does Prelude.maximum
maximum :: (Foldable t, Ord a) => t a -> Maybe a
maximum f = foldr (\a b -> Just $ maybe a (\b -> max a b) b) Nothing f

null :: (Foldable t) => t a -> Bool
null f = not $ getAny $ foldMap (\x -> Any True) f
--null f = foldr (\_ _ -> False) True f

length :: (Foldable t) => t a -> Int
length f = foldr (\_ i -> succ i) 0 f

toList :: Foldable t => t a -> [a]
toList = foldr (:) []

fold :: (Foldable t, Monoid a) => t a -> a
fold f = foldr mappend mempty f

myFoldMap :: (Foldable t, Monoid m) => (a -> m) -> t a -> m
myFoldMap g f = foldr (\i m -> g i `mappend` m) mempty f

data Constant a b = Constant a deriving Show

instance Foldable (Constant a) where
  foldMap f (Constant x) = mempty

data Two a b =
  Two a b
  deriving Show

instance Foldable (Two a) where
  foldMap f (Two a b) = f b

data Three a b c =
  Three a b c
  deriving Show

instance Foldable (Three a b) where
  foldMap f (Three a b c) = f c

data Three' a b =
  Three' a b b
  deriving Show

instance Foldable (Three' a) where
  foldMap f (Three' a b1 b2) = mappend (f b1) (f b2)

data Four' a b =
  Four' a b b b
  deriving Show

instance Foldable (Four' a) where
  foldMap f (Four' a b1 b2 b3) = (f b1) `mappend` (f b2) `mappend` (f b3)

filterF :: (Applicative f, Foldable t, Monoid (f a)) => (a -> Bool) -> t a -> f a
filterF pred f = foldMap (\x -> if pred x then pure x else mempty) f
