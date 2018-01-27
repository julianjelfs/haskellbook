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

--Identity

newtype Identity a = Identity a deriving (Eq, Show, Ord)

instance Functor Identity where
  fmap f (Identity x) = Identity (f x)

instance Foldable Identity where
  foldMap f (Identity x) = f x

instance Traversable Identity where
  traverse f (Identity x) = Identity <$> f x

--Constant

newtype Constant a b =
  Constant { getConstant :: a }

instance Functor (Constant a) where
  fmap _ (Constant x) = Constant x

instance Foldable (Constant a) where
  foldMap _ _ = mempty

instance Traversable (Constant a) where
  traverse _ (Constant x) = Constant <$> pure x

--Maybe
data Optional a
  = Nada
  | Yep a
  deriving Show

instance Monoid (Optional a) where
  mempty = Nada
  Nada `mappend` Nada = Nada
  (Yep x) `mappend` Nada = Yep x
  Nada `mappend` (Yep x) = Yep x

instance Functor Optional where
  fmap _ Nada = Nada
  fmap f (Yep x) = Yep $ f x

instance Foldable Optional where
  foldMap f Nada = mempty
  foldMap f (Yep x) = f x

instance Traversable Optional where
  traverse f Nada = pure Nada
  traverse f (Yep x) = Yep <$> f x


