module Recursion where

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
mySum n = n + (mySum  (n - 1))

recMult :: Integral a => a -> a -> a
recMult x y = go x 1
    where
        go agg count
            | count == y = agg
            | otherwise = go (agg + x) (count+1)