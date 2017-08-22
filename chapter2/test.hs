module Reverse where

rvrs :: String
rvrs = a ++ " " ++ i ++ " " ++ c
    where
        s = "Curry is awesome"
        c = take 5 s
        i = take 2 $ drop 6 s
        a = drop 9 s

main :: IO ()
main = print $ rvrs

myAbs :: Integer -> Integer
myAbs x =
    if x < 0 then
        negate x
    else
        x

f :: (a, b) -> (c, d) -> ((b, d), (a, c))
f (a, b) (c, d) = ((b, d), (a, c))

plusOne :: String -> Int
plusOne xs = n + 1
    where n = length xs

ted :: a -> a -> a
ted a b = b

jack :: a -> b -> b
jack a b = b

