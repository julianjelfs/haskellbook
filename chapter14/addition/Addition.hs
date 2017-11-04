module Addition where

import           Test.Hspec
import           Test.QuickCheck

dividedBy :: Integral a => a -> a -> (a, a)
dividedBy num denom = go num denom 0
  where
    go n d count
      | n < d = (count, n)
      | otherwise = go (n - d) d (count + 1)

recMult :: Integral a => a -> a -> a
recMult x y
  | x == 0 = 0
  | y == 0 = 0
  | y < 0 = negate $ go x (negate y) 1
  | otherwise = go x y 1
  where
    go agg target count
      | count == target = agg
      | otherwise = go (agg + x) target (count + 1)

main :: IO ()
main =
  hspec $ do
    describe "Addition" $ do
      it "15 divided by 3 is 5" $ do dividedBy 15 3 `shouldBe` (5, 0)
      it "22 divided by 5 is 4 remainder 2" $ do
        dividedBy 22 5 `shouldBe` (4, 2)
    describe "Multiply" $ do
      it "5 * 6 is 30" $ do recMult 5 6 `shouldBe` 30
      it "100 * 0 is 0" $ do recMult 100 0 `shouldBe` 0
      it "100 * -2 is -200" $ do recMult 100 (-2) `shouldBe` (-200)
      it "x + 1 is always greater than x" $ do
        property $ \x -> x + 1 > (x :: Int)
