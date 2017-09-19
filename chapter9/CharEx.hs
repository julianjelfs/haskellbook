module CharEx where

import           Data.Char

allUpper :: String -> String
allUpper str = filter isUpper str

capitalize :: String -> String
capitalize []     = []
capitalize (x:xs) = toUpper x : capitalize xs

capitalizeFirst :: String -> Char
capitalizeFirst = toUpper . head
