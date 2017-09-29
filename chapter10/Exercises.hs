module Exercises where

stops = "pbtdkg"

vowels = "aeiou"

nouns = ["tv", "hat", "dog", "table", "telescope"]

verbs = ["hits", "likes", "butchers", "dives", "mutates"]

combos l1 l2 = [(s, v, s) | s <- l1, v <- l2]

letterCombos = filter (\(s, _, _) -> s == 'p') $ combos stops vowels

wordCombos = combos nouns verbs

seekritFunct x =
  (/)
    (fromIntegral (sum (map length (words x))))
    (fromIntegral (length (words x)))

myAnd :: [Bool] -> Bool
myAnd = foldr (&&) True

myOr :: [Bool] -> Bool
myOr = foldr (||) False

myAny :: (a -> Bool) -> [a] -> Bool
myAny f = foldr (\x b -> b || f x) False

myElem :: Eq a => a -> [a] -> Bool
myElem a = foldr (\x b -> b || x == a) False

myElem2 :: Eq a => a -> [a] -> Bool
myElem2 a xs = myAny (\x -> x == a) xs

myReverse :: [a] -> [a]
myReverse = foldr (\x res -> res ++ [x]) []

--myReverse = foldl (\res x -> x : res) []
myMap :: (a -> b) -> [a] -> [b]
myMap f = foldr (\a b -> f a : b) []

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f =
  foldr
    (\x res ->
       if f x
         then x : res
         else res)
    []

squish :: [[a]] -> [a]
squish = foldr (\x res -> x ++ res) []

squishMap :: (a -> [b]) -> [a] -> [b]
squishMap f = foldr (\x res -> f x ++ res) []

squishAgain :: [[a]] -> [a]
squishAgain = squishMap id

compareBy :: Ordering -> (a -> a -> Ordering) -> [a] -> a
compareBy _ _ [] = error "error can't handle empty list"
compareBy o f xs = foldr (\x m -> if f x m == o then x else m) (head xs) xs

myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy = compareBy GT

myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy = compareBy LT

myMinimum :: (Ord a) => [a] -> a
myMinimum = myMinimumBy compare

myMaximum :: (Ord a) => [a] -> a
myMaximum = myMaximumBy compare
