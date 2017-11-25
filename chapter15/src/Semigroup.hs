module Semigroup where

import Data.Semigroup
import Test.QuickCheck

newtype Biggest a =
  Biggest a
  deriving (Eq, Show)

instance (Ord a) => Semigroup (Biggest a) where
  (<>) (Biggest a) (Biggest b)
    | a > b = Biggest a
    | a < b = Biggest b
    | otherwise = Biggest a

newtype Shortest a =
  Shortest [a]
  deriving (Eq, Show)

instance Semigroup (Shortest a) where
  (<>) (Shortest a) (Shortest b)
    | length a > length b = Shortest b
    | length a < length b = Shortest a
    | otherwise = Shortest a

data Two a b = Two a b deriving (Show, Eq)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  (Two a1 b1) <> (Two a2 b2) = Two (a1 <> a2) (b1 <> b2)

twoGen :: (Arbitrary a, Arbitrary b) => Gen (Two a b)
twoGen = do
  a <- arbitrary
  b <- arbitrary
  return (Two a b)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = twoGen

data Three a b c = Three a b c

data Four a b c d = Four a b c d


shortestGen :: Arbitrary a => Gen (Shortest a)
shortestGen = do
  a <- arbitrary
  return (Shortest a)

instance Arbitrary a => Arbitrary (Shortest a) where
  arbitrary = shortestGen

biggestGen :: Arbitrary a => Gen (Biggest a)
biggestGen = do
  a <- arbitrary
  return (Biggest a)

instance Arbitrary a => Arbitrary (Biggest a) where
  arbitrary = biggestGen


semigroupAssociativity :: (Eq s, Semigroup s) => s -> s -> s -> Bool
semigroupAssociativity x y z =
  x <> (y <> z) == (x <> y) <> z

type S = Shortest Integer
type B = Biggest Integer
type T = Two String String
type ShortestAssoc = S -> S -> S -> Bool
type BiggestAssoc = B -> B -> B -> Bool
type TwoAssoc = T -> T -> T-> Bool

testShortestAssoc :: IO ()
testShortestAssoc = do
  quickCheck (semigroupAssociativity :: ShortestAssoc)

testAssoc :: IO ()
testAssoc = do
  quickCheck (semigroupAssociativity :: ShortestAssoc)
  quickCheck (semigroupAssociativity :: BiggestAssoc)
  quickCheck (semigroupAssociativity :: TwoAssoc)

