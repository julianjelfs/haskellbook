module Exercises where

stops = "pbtdkg"

vowels = "aeiou"

nouns = ["tv", "hat", "dog", "table", "telescope"]

verbs = ["hits", "likes", "butchers", "dives", "mutates"]

combos l1 l2 =
  [ (s, v, s) | s <- l1, v <- l2 ]

letterCombos =
  filter (\(s, _, _) -> s == 'p') $ combos stops vowels

wordCombos =
  combos nouns verbs

seekritFunct x =
  (/) (fromIntegral (sum (map length (words x))))
    (fromIntegral (length (words x)))
