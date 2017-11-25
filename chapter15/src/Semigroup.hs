module Semigroup where

import Data.Semigroup
import Test.QuickCheck

newtype Biggest a =
  Biggest a
  deriving (Eq, Show)

newtype Shortest a =
  Shortest [a]
  deriving (Eq, Show)

instance Semigroup (Shortest a) where
  (<>) (Shortest a) (Shortest b)
    | length a > length b = Shortest b
    | length a < length b = Shortest a
    | otherwise = Shortest a

instance (Ord a) => Semigroup (Biggest a) where
  (<>) (Biggest a) (Biggest b)
    | a > b = Biggest a
    | a < b = Biggest b
    | otherwise = Biggest a

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

testShortestAssoc :: IO ()
testShortestAssoc = do
  quickCheck (semigroupAssociativity :: S -> S -> S -> Bool)

testBiggestAssoc :: IO ()
testBiggestAssoc = do
  quickCheck (semigroupAssociativity :: B -> B -> B -> Bool)
