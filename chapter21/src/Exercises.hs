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

--List
data List a
  = Nil
  | Cons a (List a)
  deriving Show

append x Nil = Cons x Nil
append x (Cons y Nil) = Cons y (Cons x Nil)
append x (Cons y l) = (Cons y (append x l))

instance Monoid (List a) where
  mempty = Nil
  Nil `mappend` l = l
  l `mappend` Nil = l
  l1 `mappend` (Cons x l2) = append x l1 `mappend` l2

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons x l) = Cons (f x) (fmap f l)

instance Foldable List where
  foldMap _ Nil = mempty
  foldMap f (Cons x l) = f x `mappend` foldMap f l

--don't understand that at all
instance Traversable List where
  traverse f Nil = pure Nil
  traverse f (Cons x l) = Cons <$> f x <*> traverse f l

--three
data Three a b c = Three a b c deriving Show

instance Functor (Three a b) where
  fmap f (Three x y z) = Three x y (f z)

instance Foldable (Three a b) where
  foldMap f (Three x y z) = f z

instance Traversable (Three a b) where
  traverse f (Three x y z) = Three x y <$> f z

--three'
data Three' a b = Three' a b b deriving Show

instance Functor (Three' a) where
  fmap f (Three' x y z) = Three' x (f y) (f z)

instance Foldable (Three' a) where
  foldMap f (Three' x y z) = f y `mappend` f z

instance Traversable (Three' a) where
  traverse f (Three' x y z) = Three' x <$> f y <*> f z

--S
data S n a = S (n a) a deriving Show

instance Functor n => Functor (S n) where
  fmap f (S n a) = S (fmap f n) (f a)

instance Foldable n => Foldable (S n) where
  foldMap f (S n a) = foldMap f n `mappend` f a

instance Traversable n => Traversable (S n) where
  traverse f (S n a) = S <$> traverse f n <*> f a

--Tree
data Tree a
  = Empty
  | Leaf a
  | Node (Tree a) a (Tree a)
  deriving (Eq, Show)

instance Functor Tree where
  fmap _ Empty = Empty
  fmap f (Leaf a) = Leaf (f a)
  fmap f (Node l n r) = Node (fmap f l) (f n) (fmap f r)

instance Foldable Tree where
  foldMap _ Empty = mempty
  foldMap f (Leaf a) = f a
  foldMap f (Node l n r) = foldMap f l `mappend` (f n) `mappend` foldMap f r

instance Traversable Tree where
  traverse _ Empty = pure Empty
  traverse f (Leaf a) = Leaf <$> f a
  traverse f (Node l n r) =
    Node <$> traverse f l <*> f n <*> traverse f r
