module Anon where

addOneIfOdd n =
  case odd n of
    True  -> f n
    False -> n
  where
    f = \n -> n + 1

addFive =
  \x y ->
    (if x > y
       then y
       else x) +
    5

mFlip f x y = f x y

f :: (a, b, c) -> (d, e, f) -> ((a, d), (c, f))
f (a, b, c) (d, e, f) = ((a, d), (c, f))
