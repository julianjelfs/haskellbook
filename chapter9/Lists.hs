module Lists where

eftBool :: Bool -> Bool -> [Bool]
eftBool a b = enumFromThen a b

eftOrd :: Ordering -> Ordering -> [Ordering]
eftOrd a b = enumFromThen a b

eftInt :: Int -> Int -> [Int]
eftInt a b = enumFromThen a b

eftChar :: Char -> Char -> [Char]
eftChar a b = enumFromThen a b

myWords :: String -> [String]
myWords sentence = reverse $ go [] sentence
  where
    go words sentence
      | sentence == [] = words
      | otherwise =
        let
          trim = dropWhile ((==) ' ') sentence
          word = takeWhile ((/=) ' ') trim
          next = dropWhile ((/=) ' ') trim
        in
          go (word : words) next

