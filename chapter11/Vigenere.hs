module Vigenere where

import           Data.Char

applyOffset :: Int -> Int
applyOffset n = mod n 26

offsetChar :: Int -> Char -> Char
offsetChar _ ' '    = ' '
offsetChar offset c = chr $ (+ 65) $ applyOffset $ ((ord c) - 65) + offset

keyWord = "ALLY"
testStr = "MEET AT DAWN"

offset :: Char -> Int
offset c =
  (ord c) - 65

cipherLetter :: (Int, String) -> Char -> (Int, String)
cipherLetter  (i, res) ' ' = (i, res ++ [' '])
cipherLetter (i, res) letter =
  let
    cl = keyWord !! mod i 4
    c = offsetChar (offset cl) letter
  in
    (i + 1, res ++ [c])


cipher str =
  snd $ foldl cipherLetter (0, []) str

