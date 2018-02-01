{-# LANGUAGE InstanceSigs #-}

module ReaderStuff where

import Control.Applicative
import Data.Char
import Control.Monad

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

newtype Reader r a =
  Reader { runReader :: r -> a }

myLiftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
myLiftA2 f a1 a2 = f <$> a1 <*> a2

asks :: (r -> a) -> Reader r a
asks f = Reader f

instance Functor (Reader r) where
  fmap f (Reader ra) = Reader $ f . ra

instance Applicative (Reader r) where
  pure :: a -> Reader r a
  pure a = Reader $ (\r -> a)

  (<*>) :: Reader r (a -> b)
        -> Reader r a
        -> Reader r b
  (Reader rab) <*> (Reader ra) =
    Reader $ \r -> rab r $ ra r

instance Monad (Reader r) where
  return = pure
  (>>=) :: Reader r a
        -> (a -> Reader r b)
        -> Reader r b
  (Reader ra) >>= arb =
    join $ Reader $ \r -> arb (ra r)
