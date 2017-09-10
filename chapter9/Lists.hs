module Lists where

eftBool :: Bool -> Bool -> [Bool]
eftBool a b = enumFromThen a b

eftOrd :: Ordering -> Ordering -> [Ordering]
eftOrd a b = enumFromThen a b

eftInt :: Int -> Int -> [Int]
eftInt a b = enumFromThen a b

eftChar :: Char -> Char -> [Char]
eftChar a b = enumFromThen a b
