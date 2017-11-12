module WordNumberTest where

import Test.Hspec
import Test.QuickCheck
import Recursion (digitToWord, digits, wordNumber)
import Data.List (sort)

listOrdered :: (Ord a) => [a] -> Bool
listOrdered xs =
  snd $ foldr go (Nothing, True) xs
  where go _ status@(_, False) = status
        go y (Nothing, t) = (Just y, t)
        go y (Just x, t) = (Just y, x >= y)

sortListGen :: (Ord a, Arbitrary a) => Gen [a]
sortListGen = do
  l <- arbitrary
  return $ sort l

sortListGenInt :: Gen [Int]
sortListGenInt = sortListGen

sortListGenString :: Gen [String]
sortListGenString = sortListGen

prop_sorted :: Property
prop_sorted =
  forAll sortListGenString (\l -> listOrdered l)

testSorted :: IO ()
testSorted = quickCheck prop_sorted

half :: Fractional a => a -> a
half x = x / 2

halfIdentity :: Fractional a => a -> a
halfIdentity = (*2) . half

prop :: Double -> Bool
prop x =
  x == halfIdentity x


test :: IO ()
test =
  quickCheck prop

main :: IO()
main = hspec $ do
  describe "digitToWord" $ do
    it "returns zero for 0" $ do
      digitToWord 0 `shouldBe` "zero"
    it "returns one for 1" $ do
      digitToWord 1 `shouldBe` "one"

  describe "digits" $ do
    it "returns [1] for 1" $ do
      digits 1 `shouldBe` [1]
    it "returns [1,0,0] for 100" $ do
      digits 100 `shouldBe` [1,0,0]

  describe "wordNumber" $ do
    it "returns one-zero-zero for 100" $ do
      wordNumber 100 `shouldBe` "one-zero-zero"
    it "returns nine-zero-zero-one for 9001" $ do
      wordNumber 9001 `shouldBe` "nine-zero-zero-one"
