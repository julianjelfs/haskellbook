module Semigroup where

import           Data.Semigroup
import           Test.QuickCheck

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

data Two a b =
  Two a
      b
  deriving (Show, Eq)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  (Two a1 b1) <> (Two a2 b2) = Two (a1 <> a2) (b1 <> b2)

twoGen :: (Arbitrary a, Arbitrary b) => Gen (Two a b)
twoGen = do
  a <- arbitrary
  b <- arbitrary
  return (Two a b)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = twoGen

data Three a b c =
  Three a
        b
        c
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b, Semigroup c) =>
         Semigroup (Three a b c) where
  (Three a1 b1 c1) <> (Three a2 b2 c2) = Three (a1 <> a2) (b1 <> b2) (c1 <> c2)

threeGen :: (Arbitrary a, Arbitrary b, Arbitrary c) => Gen (Three a b c)
threeGen = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  return (Three a b c)

instance (Arbitrary a, Arbitrary b, Arbitrary c) =>
         Arbitrary (Three a b c) where
  arbitrary = threeGen

data Four a b c d =
  Four a
       b
       c
       d
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b, Semigroup c, Semigroup d) =>
         Semigroup (Four a b c d) where
  (Four a1 b1 c1 d1) <> (Four a2 b2 c2 d2) =
    Four (a1 <> a2) (b1 <> b2) (c1 <> c2) (d1 <> d2)

fourGen ::
     (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Gen (Four a b c d)
fourGen = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  d <- arbitrary
  return (Four a b c d)

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) =>
         Arbitrary (Four a b c d) where
  arbitrary = fourGen

newtype BoolConj =
  BoolConj Bool
  deriving (Eq, Show)

instance Semigroup BoolConj where
  (BoolConj a) <> (BoolConj b) = BoolConj (a && b)

boolConjGen :: Gen BoolConj
boolConjGen = do
  a <- arbitrary
  return (BoolConj a)

instance Arbitrary BoolConj where
  arbitrary = boolConjGen

newtype BoolDisj =
  BoolDisj Bool
  deriving (Eq, Show)

instance Semigroup BoolDisj where
  (BoolDisj a) <> (BoolDisj b) = BoolDisj (a || b)

boolDisjGen :: Gen BoolDisj
boolDisjGen = do
  a <- arbitrary
  return (BoolDisj a)

instance Arbitrary BoolDisj where
  arbitrary = boolDisjGen

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

data Or a b
  = Fst a
  | Snd b
  deriving (Eq, Show)

orGen :: (Arbitrary a, Arbitrary b) => Gen (Or a b)
orGen = do
  a <- arbitrary
  b <- arbitrary
  oneof [return $ Fst a, return $ Snd b]

instance (Arbitrary a, Arbitrary b) =>  Arbitrary (Or a b) where
  arbitrary = orGen

instance Semigroup (Or a b) where
  (Snd a) <> (Snd b) = Snd a
  (Fst a) <> (Snd b) = Snd b
  (Snd a) <> (Fst b) = Snd a
  (Fst a) <> (Fst b) = Fst b


semigroupAssociativity :: (Eq s, Semigroup s) => s -> s -> s -> Bool
semigroupAssociativity x y z = x <> (y <> z) == (x <> y) <> z

type S = Shortest Integer

type B = Biggest Integer

type T = Two String String

type Th = Three String String String

type F = Four String String String String

type Bc = BoolConj

type Bd = BoolDisj

type O = Or Int Int

type ShortestAssoc = S -> S -> S -> Bool

type BiggestAssoc = B -> B -> B -> Bool

type TwoAssoc = T -> T -> T -> Bool

type ThreeAssoc = Th -> Th -> Th -> Bool

type FourAssoc = F -> F -> F -> Bool

type BoolConjAssoc = Bc -> Bc -> Bc -> Bool

type BoolDisjAssoc = Bd -> Bd -> Bd -> Bool

type OrAssoc = O -> O -> O -> Bool

testAssoc :: IO ()
testAssoc = do
  quickCheck (semigroupAssociativity :: ShortestAssoc)
  quickCheck (semigroupAssociativity :: BiggestAssoc)
  quickCheck (semigroupAssociativity :: TwoAssoc)
  quickCheck (semigroupAssociativity :: ThreeAssoc)
  quickCheck (semigroupAssociativity :: FourAssoc)
  quickCheck (semigroupAssociativity :: BoolConjAssoc)
  quickCheck (semigroupAssociativity :: BoolDisjAssoc)
  quickCheck (semigroupAssociativity :: OrAssoc)
