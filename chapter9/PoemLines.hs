module PoemLines where

firstSen = "Tyger Tyger, burning bright\n"
secondSen = "In the forests of the night\n"
thirdSen = "What immortal hand or eye\n"
fourthSen = "Could frame thy fearful symmetry?"

sentences = firstSen ++ secondSen ++ thirdSen ++ fourthSen

myLines :: String -> [String]
myLines para = reverse $ go [] para
  where
    go lines para
      | para == [] = lines
      | otherwise =
        let
          trim = dropWhile ((==) '\n') para
          line = takeWhile ((/=) '\n') trim
          rest = dropWhile ((/=) '\n') trim
        in
          go (line : lines) rest

splitOn :: Char -> String -> [String]
splitOn c sentence = reverse $ go [] sentence
  where
    go words sentence
      | sentence == [] = words
      | otherwise =
        let
          trim = dropWhile ((==) c) sentence
          word = takeWhile ((/=) c) trim
          next = dropWhile ((/=) c) trim
        in
          go (word : words) next
