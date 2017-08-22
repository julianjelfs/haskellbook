{-# LANGUAGE NoMonomorphismRestriction #-}

module DetermineTheType where

example = 1

one = (* 9) 6

two = head [(0, "doge"), (1, "kitteh")] --(Num, [Char])

three = head [(0 :: Integer, "doge"), (1, "kitteh")]    --(Integer, [Char])

four = if False then True else False    --Bool

five = length [1,2,3,4,5]   --Int

six = (length [1,2,3,4]) > (length "TACOCAT")   --Bool

bignum = (^) 5

wahoo = bignum $ 10

a = 12 + b

c = 10

b = 10000 * c

--functionH :: [a] -> a
functionH (x:_) = x

--functionC :: Ord a => a -> a -> Bool
functionC x y = if (x > y) then True else False

--functionS :: (a, b) -> b
functionS (x, y) = y



