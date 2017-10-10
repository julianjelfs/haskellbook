module As where

import           Data.Char

isSubsequenceOf :: (Eq a) => [a] -> [a] -> Bool
isSubsequenceOf [] ys     = True
isSubsequenceOf (x:xs) ys = elem x ys && isSubsequenceOf xs ys

capitalizeWord :: String -> String
capitalizeWord []    = []
capitalizeWord (h:t) = toUpper h : t

capitalizeWords :: String -> [(String, String)]
capitalizeWords sentence = map (\w -> (w, capitalizeWord w)) $ words sentence

capitalizeParagraph :: String -> String
capitalizeParagraph para =
  fst $
  foldl
    (\(str, capitalize) w ->
       ( str ++
         [' '] ++
         (if capitalize
            then capitalizeWord w
            else w)
       , if (last w == '.')
           then True
           else False))
    ([], True) $
  words para
