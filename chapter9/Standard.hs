module Standard where

myOr :: [Bool] -> Bool
myOr []     = False
myOr (x:xs) = x || myOr xs

myAny :: (a -> Bool) -> [a] -> Bool
myAny f []     = False
myAny f (x:xs) = f x || myAny f xs

myElem :: Eq a => a -> [a] -> Bool
myElem _ [] = False
myElem a (x:xs)
  | a == x = True
  | otherwise = myElem a xs

myElem2 :: Eq a => a -> [a] -> Bool
myElem2 a xs = myAny (\x -> x == a) xs

myReverse :: [a] -> [a]
myReverse xs = go xs []
  where
    go [] res     = res
    go (x:xs) res = go xs (x : res)

squish :: [[a]] -> [a]
squish xs = go xs []
  where
    go [] res     = res
    go (x:xs) res = go xs (res ++ x)

squishMap :: (a -> [b]) -> [a] -> [b]
squishMap f xs = go f xs []
  where
    go _ [] res     = res
    go f (x:xs) res = go f xs (res ++ (f x))

squishAgain :: [[a]] -> [a]
squishAgain = squishMap id

compareBy :: Ordering -> (a -> a -> Ordering) -> [a] -> a
compareBy _ _ [] = error "error can't handle empty list"
compareBy o comp (x:xs) = go comp xs x
  where
    go _ [] m = m
    go comp (x:xs) m =
      if comp x m == o
        then go comp xs x
        else go comp xs m

myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy = compareBy GT

myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy = compareBy LT

myMinimum :: (Ord a) => [a] -> a
myMinimum = myMinimumBy compare

myMaximum :: (Ord a) => [a] -> a
myMaximum = myMaximumBy compare
