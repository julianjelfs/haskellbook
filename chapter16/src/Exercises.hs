module Exercises where

import Test.QuickCheck
import Test.QuickCheck.Function

functorCompose :: (Eq (f c), Functor f) =>
                    f a
                    -> Fun a b
                    -> Fun b c
                    -> Bool
functorCompose x (Fun _ f) (Fun _ g) =
  (fmap (g . f) x) == (fmap g . fmap f $ x)

------------------------------------------------------
--  Identity
------------------------------------------------------
newtype Identity a = Identity a deriving (Eq, Show)

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
--data Pair a = Pair a a deriving (Eq, Show)

--instance Functor Pair where
--  fmap f (Pair x y) = Pair x y

------------------------------------------------------
--  Two
------------------------------------------------------
data Two a b = Two a b deriving (Eq, Show)

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
  quickCheck (functorCompose :: Two String String -> StrToStr -> StrToStr -> Bool)
  quickCheck (functorCompose :: Two Int Int -> IntToInt -> IntToInt -> Bool)
