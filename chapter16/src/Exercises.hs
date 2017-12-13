module Exercises where

import Test.QuickCheck
import Test.QuickCheck.Function

functorCompose :: (Eq (f c), Functor f) => f a -> Fun a b -> Fun b c -> Bool
functorCompose x (Fun _ f) (Fun _ g) = (fmap (g . f) x) == (fmap g . fmap f $ x)

------------------------------------------------------
--  Identity
------------------------------------------------------
newtype Identity a =
  Identity a
  deriving (Eq, Show)

instance Functor Identity where
  fmap f (Identity x) = Identity (f x)

idGen :: (Arbitrary a) => Gen (Identity a)
idGen = do
  a <- arbitrary
  return $ Identity a

instance (Arbitrary a) => Arbitrary (Identity a) where
  arbitrary = idGen

type StrToStr = Fun String String

type IntToInt = Fun Int Int

testIdentity = do
  quickCheck (functorCompose :: Identity String -> StrToStr -> StrToStr -> Bool)
  quickCheck (functorCompose :: Identity Int -> IntToInt -> IntToInt -> Bool)

------------------------------------------------------
--  Pair
------------------------------------------------------
data Pair a =
  Pair a
       a
  deriving (Eq, Show)

instance Functor Pair where
  fmap f (Pair x y) = Pair (f x) (f y)

pairGen :: (Arbitrary a) => Gen (Pair a)
pairGen = do
  x <- arbitrary
  y <- arbitrary
  return $ Pair x y

instance (Arbitrary a) => Arbitrary (Pair a) where
  arbitrary = pairGen

testPair = do
  quickCheck (functorCompose :: Pair String -> StrToStr -> StrToStr -> Bool)

------------------------------------------------------
--  Two
------------------------------------------------------
data Two a b =
  Two a
      b
  deriving (Eq, Show)

instance Functor (Two a) where
  fmap f (Two a b) = Two a (f b)

twoGen :: (Arbitrary a, Arbitrary b) => Gen (Two a b)
twoGen = do
  a <- arbitrary
  b <- arbitrary
  return $ Two a b

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = twoGen

testTwo = do
  quickCheck
    (functorCompose :: Two String String -> StrToStr -> StrToStr -> Bool)
  quickCheck (functorCompose :: Two Int Int -> IntToInt -> IntToInt -> Bool)

------------------------------------------------------
--  Three
------------------------------------------------------
data Three a b c =
  Three a
        b
        c
  deriving (Eq, Show)

instance Functor (Three a b) where
  fmap f (Three a b c) = Three a b (f c)

threeGen :: (Arbitrary a, Arbitrary b, Arbitrary c) => Gen (Three a b c)
threeGen = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  return $ Three a b c

instance (Arbitrary a, Arbitrary b, Arbitrary c) =>
         Arbitrary (Three a b c) where
  arbitrary = threeGen

testThree = do
  quickCheck
    (functorCompose :: Three String String String -> StrToStr -> StrToStr -> Bool)

------------------------------------------------------
--  Three'
------------------------------------------------------
data Three' a b =
  Three' a
         b
         b
  deriving (Eq, Show)

instance Functor (Three' a) where
  fmap f (Three' x y z) = Three' x (f y) (f z)

threeGen' :: (Arbitrary a, Arbitrary b) => Gen (Three' a b)
threeGen' = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  return $ Three' a b c

instance (Arbitrary a, Arbitrary b) => Arbitrary (Three' a b) where
  arbitrary = threeGen'

testThree' = do
  quickCheck
    (functorCompose :: Three' String String -> StrToStr -> StrToStr -> Bool)

------------------------------------------------------
--  Four
------------------------------------------------------
data Four a b c d =
  Four a
       b
       c
       d
  deriving (Eq, Show)

instance Functor (Four a b c) where
  fmap f (Four a b c d) = Four a b c (f d)

fourGen ::
     (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Gen (Four a b c d)
fourGen = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  d <- arbitrary
  return $ Four a b c d

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) =>
         Arbitrary (Four a b c d) where
  arbitrary = fourGen

testFour = do
  quickCheck
    (functorCompose :: Four String String String String -> StrToStr -> StrToStr -> Bool)

------------------------------------------------------
--  Four'
------------------------------------------------------
data Four' a b =
  Four' a
        a
        a
        b
  deriving (Eq, Show)

instance Functor (Four' a) where
  fmap f (Four' w x y z) = Four' w x y (f z)

fourGen' :: (Arbitrary a, Arbitrary b) => Gen (Four' a b)
fourGen' = do
  a <- arbitrary
  b <- arbitrary
  c <- arbitrary
  d <- arbitrary
  return $ Four' a b c d

instance (Arbitrary a, Arbitrary b) => Arbitrary (Four' a b) where
  arbitrary = fourGen'

testFour' = do
  quickCheck
    (functorCompose :: Four' String String -> StrToStr -> StrToStr -> Bool)

data Wrap f a =
  Wrap (f a)
  deriving (Eq, Show)

instance Functor f => Functor (Wrap f) where
  fmap f (Wrap fa) = Wrap (fmap f fa)

getInt :: IO Int
getInt = fmap read getLine

data BoolAndSomethingElse a
  = False' a
  | True' a
  deriving (Show)

instance Functor BoolAndSomethingElse where
  fmap f (False' a) = False' (f a)
  fmap f (True' a) = True' (f a)

data BoolAndMaybeSomethingElse a
  = Falsish
  | Truish a
  deriving (Show)

instance Functor BoolAndMaybeSomethingElse where
  fmap f (Truish a) = Truish (f a)
  fmap _ Falsish = Falsish

--don't understand this one at all
newtype Mu f = InF
  { outF :: f (Mu f)
  }

data Sum b a
  = First a
  | Second b
  deriving (Show)

instance Functor (Sum e) where
  fmap f (First a) = First (f a)
  fmap f (Second b) = Second b

data Company a c b =
  DeepBlue a c
  | Something b

instance Functor (Company e e') where
  fmap f (Something b) = Something (f b)
  fmap f (DeepBlue a c) = DeepBlue a c

data More b a =
  L a b a
  | R b a b
  deriving (Eq, Show)

instance Functor (More x) where
  fmap f (L a b a') = L (f a) b (f a')
  fmap f (R b a b') = R b (f a) b'
