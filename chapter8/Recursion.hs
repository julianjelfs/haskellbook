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

data DivideByResult a =
    Result (a, a)
    | DivideByZero
    deriving (Show)

dividedBy :: Integral a => a -> a -> DivideByResult a
dividedBy num 0 = DivideByZero
dividedBy num denom =
    let
        (quo, rem) = go (abs num) (abs denom) 0
        negate = (length . filter (\x -> x < 0) $ [num, denom]) == 1
    in
        if negate then
            Result (quo * (-1), rem)
        else
            Result (quo, rem)
    where
        go n d count
            | n < d = (count, n)
            | otherwise = go (n - d) d (count + 1)