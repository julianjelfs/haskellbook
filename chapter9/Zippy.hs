module Zippy where

myZip :: [a] -> [b] -> [(a, b)]
myZip = myZipWith (\x y -> (x, y))

myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith f xs ys = reverse $ go f xs ys []
  where
    go f [] _ result          = result
    go f _ [] result          = result
    go f (x:xs) (y:ys) result = go f xs ys (f x y : result)
