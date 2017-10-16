module StringProcessing where

import           Data.List

replaceThe :: String -> String
replaceThe = intercalate " " . (map checkWord) . words

checkWord :: String -> String
checkWord w =
  case notThe w of
    Nothing -> "a"
    Just n  -> n

notThe :: String -> Maybe String
notThe word
  | word == "the" = Nothing
  | otherwise = Just word

vowels = "aeiouAEIOU"

isVowel :: Char -> Bool
isVowel c = elem c vowels

beginsWithVowel :: String -> Bool
beginsWithVowel (h:_) = isVowel h
beginsWithVowel []    = False

countTheBeforeVowel :: String -> Integer
countTheBeforeVowel = go False 0 . words
  where
    go :: Bool -> Integer -> [String] -> Integer
    go _ n [] = n
    go check n (h:t) =
      case check of
        True ->
          if beginsWithVowel h
            then go False (n + 1) t
            else go (h == "the") n t
        False -> go (h == "the") n t

numberOfVowels :: String -> Int
numberOfVowels = length . filter isVowel

newtype Word' =
  Word' String
  deriving (Eq, Show)

mkWord :: String -> Maybe Word'
mkWord w =
  let v = numberOfVowels w
      c = length w - v
  in if v > c
       then Nothing
       else Just $ Word' w

data Nat =
  Zero
  | Succ Nat
  deriving (Eq, Show)

natToInteger :: Nat -> Integer
natToInteger Zero = 0
natToInteger (Succ n) = 1 + natToInteger n

integerToNat :: Integer -> Maybe Nat
integerToNat i
  | i < 0 = Nothing
  | otherwise = Just $ go i
      where
        go :: Integer -> Nat
        go i
          | i == 0 = Zero
          | otherwise = Succ (go $ i - 1)
