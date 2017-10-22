module Unfolds where

import           Data.List

myIterate :: (a -> a) -> a -> [a]
myIterate f x = [x] ++ myIterate f (f x)

betterIterate :: (a -> a) -> a -> [a]
betterIterate f x =
  myUnfoldr (\b -> Just (b, f b)) x

myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a]
myUnfoldr f x =
  case f x of
    Just (a, b) -> [a] ++ myUnfoldr f b
    Nothing     -> []

testUnfold = take 5 $ myUnfoldr (\b -> Just (b, b + 1)) 0

testUnfold2 =
  take 20 $
  myUnfoldr
    (\b ->
       if b > 5
         then Nothing
         else (Just (b, b + 1)))
    0
