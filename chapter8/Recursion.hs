module Recursion where

import           Data.List (intersperse)

cattyConny :: String -> String -> String
cattyConny x y = x ++ " mrow " ++ y

flippy :: String -> String -> String
flippy = flip cattyConny

appedCatty :: String -> String
appedCatty = cattyConny "woops"

frappe :: String -> String
frappe = flippy "haha"

mySum :: (Eq a, Num a) => a -> a
mySum 1 = 1
mySum n = n + (mySum (n - 1))

recMult :: Integral a => a -> a -> a
recMult x y = go x 1
  where
    go agg count
      | count == y = agg
      | otherwise = go (agg + x) (count + 1)

data DivideByResult a
  = Result (a, a)
  | DivideByZero
  deriving (Show)

dividedBy :: Integral a => a -> a -> DivideByResult a
dividedBy num 0 = DivideByZero
dividedBy num denom =
  let (quo, rem) = go (abs num) (abs denom) 0
      negate = (length . filter (\x -> x < 0) $ [num, denom]) == 1
  in if negate
       then Result (quo * (-1), rem)
       else Result (quo, rem)
  where
    go n d count
      | n < d = (count, n)
      | otherwise = go (n - d) d (count + 1)

mc91 :: Integral a => a -> a
mc91 n
  | n > 100 = n - 10
  | otherwise = mc91 . mc91 $ n + 11


digitToWord :: Int -> String
digitToWord 0 = "zero"
digitToWord 1 = "one"
digitToWord 2 = "two"
digitToWord 3 = "three"
digitToWord 4 = "four"
digitToWord 5 = "five"
digitToWord 6 = "six"
digitToWord 7 = "seven"
digitToWord 8 = "eight"
digitToWord 9 = "nine"
digitToWord _ = "unknown"

digits :: Int -> [Int]
digits n = reverse $ go n []
  where
    go num ds
      | num < 10 = num : ds
      | otherwise =
        let (h, t) = divMod num 10
        in t : go h ds


wordNumber :: Int -> String
wordNumber n = concat . intersperse "-" . map digitToWord . digits $ n


