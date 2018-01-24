module Exercises where

--traverse applies a function that adds structure but then flips that structure to the outside

-- traverse Just [1,2,3]
-- Just [1,2,3]
-- vs
-- fmap Just [1,2,3]
-- [Just 1, Just 2, Just 3]
-- vs
-- sequence $ fmap Just [1,2,3]
-- Just [1,2,3]

newtype Identity a = Identity a deriving (Eq, Show, Ord)

instance Functor Identity where
  fmap f (Identity x) = Identity (f x)

instance Foldable Identity where
  foldMap f (Identity x) = f x

instance Traversable Identity where
  traverse f (Identity x) = Identity <$> f x