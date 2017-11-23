module WordNumberTest where

import           Data.List       (sort)
import           Recursion       (digitToWord, digits, wordNumber)
import           Test.Hspec
import           Test.QuickCheck

add3 = (+) 3

add5 = (+) 5

applyProp :: Int -> Bool
applyProp a = (add3 $ a) == (add3 a)

testApply :: IO ()
testApply = quickCheck (applyProp :: Int -> Bool)

composeProp :: Int -> Bool
composeProp a = (add3 . add5 $ a) == ((\a -> add5 (add3 a)) a)

testCompose :: IO ()
testCompose = quickCheck (composeProp :: Int -> Bool)

revProp :: (Eq a) => [a] -> Bool
revProp l = (reverse . reverse $ l) == (id l)

testRev :: IO ()
testRev = quickCheck (revProp :: [Int] -> Bool)

genPos :: Gen Int
genPos = abs `fmap` (arbitrary :: Gen Int) `suchThat` (> 0)

genPair = do
  x <- genPos
  y <- genPos
  return (x, y)

mathProp ::
     (Integral a, Eq a) => (a -> a -> a) -> (a -> a -> a) -> (a, a) -> Bool
mathProp f g (x, y) = (f x y) * y + (g x y) == x

testQuotRem :: IO ()
testQuotRem = do
  quickCheck $ forAll genPair $ (mathProp quot rem)

testDivMod :: IO ()
testDivMod = do
  quickCheck $ forAll genPair $ (mathProp div mod)

--power associativity
powAssociative :: (Eq a, Integral a) => a -> a -> a -> Bool
powAssociative x y z = x ^ (y ^ z) == (x ^ y) ^ z

testPowAssociative :: IO ()
testPowAssociative = quickCheck (powAssociative :: Int -> Int -> Int -> Bool)

--power commutative
powCommutative :: (Eq a, Integral a) => a -> a -> Bool
powCommutative x y = x ^ y == y ^ x

testPowCommutative :: IO ()
testPowCommutative = quickCheck (powCommutative :: Int -> Int -> Bool)

--plus associativity
plusAssociative :: (Eq a, Num a) => a -> a -> a -> Bool
plusAssociative x y z = x + (y + z) == (x + y) + z

testPlusAssociative :: IO ()
testPlusAssociative = quickCheck (plusAssociative :: Int -> Int -> Int -> Bool)

--plus commutative
plusCommutative :: (Eq a, Num a) => a -> a -> Bool
plusCommutative x y = x + y == y + x

testPlusCommutative :: IO ()
testPlusCommutative = quickCheck (plusCommutative :: Int -> Int -> Bool)

--mult associative
multAssociative :: (Eq a, Num a) => a -> a -> a -> Bool
multAssociative x y z = x * (y * z) == (x * y) * z

testMultAssociative :: IO ()
testMultAssociative = quickCheck (multAssociative :: Int -> Int -> Int -> Bool)

--mult commutative
multCommutative :: (Eq a, Num a) => a -> a -> Bool
multCommutative x y = x * y == y * x

testMultCommutative :: IO ()
testMultCommutative = quickCheck (multCommutative :: Int -> Int -> Bool)

listOrdered :: (Ord a) => [a] -> Bool
listOrdered xs = snd $ foldr go (Nothing, True) xs
  where
    go _ status@(_, False) = status
    go y (Nothing, t)      = (Just y, t)
    go y (Just x, t)       = (Just y, x >= y)

sortListGen :: (Ord a, Arbitrary a) => Gen [a]
sortListGen = do
  l <- arbitrary
  return $ sort l

sortListGenInt :: Gen [Int]
sortListGenInt = sortListGen

sortListGenString :: Gen [String]
sortListGenString = sortListGen

prop_sorted :: Property
prop_sorted = forAll sortListGenString (\l -> listOrdered l)

testSorted :: IO ()
testSorted = quickCheck prop_sorted

half :: Fractional a => a -> a
half x = x / 2

halfIdentity :: Fractional a => a -> a
halfIdentity = (* 2) . half

prop :: Double -> Bool
prop x = x == halfIdentity x

test :: IO ()
test = quickCheck prop

main :: IO ()
main =
  hspec $ do
    describe "digitToWord" $ do
      it "returns zero for 0" $ do digitToWord 0 `shouldBe` "zero"
      it "returns one for 1" $ do digitToWord 1 `shouldBe` "one"
    describe "digits" $ do
      it "returns [1] for 1" $ do digits 1 `shouldBe` [1]
      it "returns [1,0,0] for 100" $ do digits 100 `shouldBe` [1, 0, 0]
    describe "wordNumber" $ do
      it "returns one-zero-zero for 100" $ do
        wordNumber 100 `shouldBe` "one-zero-zero"
      it "returns nine-zero-zero-one for 9001" $ do
        wordNumber 9001 `shouldBe` "nine-zero-zero-one"
