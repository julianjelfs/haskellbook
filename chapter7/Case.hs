module Case where

functionC x y =
  case x > y of
    True  -> x
    False -> y

ifEvenAdd2 n =
  case even n of
    True  -> n + 2
    False -> n

nums x =
  case compare x 0 of
    LT -> -1
    GT -> 1
    EQ -> 0

dodgy x y = x + y * 10

oneIsOne = dodgy 1

oneIsTwo = (flip dodgy) 2
