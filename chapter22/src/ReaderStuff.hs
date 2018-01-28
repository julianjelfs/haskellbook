module ReaderStuff where

import Control.Applicative
import Data.Char

boop :: Num a => a -> a
boop = (*2)

doop :: Num a => a -> a
doop = (+10)

bip :: Num a => a -> a
bip = boop . doop

bloop :: Num a => a -> a
bloop = fmap boop doop

bbop :: Num a => a -> a
bbop = (+) <$> boop <*> doop

duwop :: Num a => a -> a
duwop = liftA2 (+) boop doop

cap :: [Char] -> [Char]
cap xs = map toUpper xs

rev :: [Char] -> [Char]
rev xs = reverse xs

composed :: [Char] -> [Char]
composed = rev . cap

fmapped :: [Char] -> [Char]
fmapped = fmap rev cap

tupled :: [Char] -> ([Char], [Char])
tupled =
  (,) <$> cap <*> rev

mtupleddo :: [Char] -> ([Char], [Char])
mtupleddo = do
  a <- cap
  b <- rev
  return (a, b)

mtupled :: [Char] -> ([Char], [Char])
mtupled =
  cap >>= (\a -> rev >>= (\b -> return (a, b)))