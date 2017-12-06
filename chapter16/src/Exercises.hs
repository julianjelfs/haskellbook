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
