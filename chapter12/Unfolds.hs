module Unfolds where

import           Data.List

data BinaryTree a
  = Leaf
  | Node (BinaryTree a)
         a
         (BinaryTree a)
  deriving (Eq, Ord, Show)

unfoldTree :: (a -> Maybe (a, b, a)) -> a -> BinaryTree b
unfoldTree f a =
  case f a of
    Nothing        -> Leaf
    Just (x, y, z) -> Node (unfoldTree f x) y (unfoldTree f z)

treeBuild :: Integer -> BinaryTree Integer
treeBuild n =
  unfoldTree
    (\a ->
       if a == n
         then Nothing
         else Just (a + 1, a, a + 1))
    0

myIterate :: (a -> a) -> a -> [a]
myIterate f x = [x] ++ myIterate f (f x)

betterIterate :: (a -> a) -> a -> [a]
betterIterate f x = myUnfoldr (\b -> Just (b, f b)) x

myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a]
myUnfoldr f x =
  case f x of
    Just (a, b) -> [a] ++ myUnfoldr f b
    Nothing     -> []

testUnfold = take 5 $ myUnfoldr (\b -> Just (b, b + 1)) 0

testUnfold2 =
  take 20 $
  myUnfoldr
    (\b ->
       if b > 5
         then Nothing
         else (Just (b, b + 1)))
    0
