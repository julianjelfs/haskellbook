module Swap where

import           Data.List

jung :: [Int] -> Int
jung xs = head $ sort xs

young :: Ord a => [a] -> a
young = head . sort

mySort :: Ord a => [a] -> [a]
mySort = sort

signifier :: Ord a => [a] -> a
signifier xs = head (mySort xs)

chk :: Eq b => (a -> b) -> a -> b -> Bool
chk aTob a b = b == aTob a

arith :: Num b => (a -> b) -> Integer -> a -> b
arith aTob i a = b * (fromInteger i)
  where
    b = aTob a
