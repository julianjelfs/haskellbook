{-# LANGUAGE NoMonomorphismRestriction #-}

module WriteTheFunctions where

i :: a -> a
i a = a

c :: a -> b -> a
c a b = a

c'' :: b -> a -> b
c'' b a = b

c' :: a -> b -> b
c' a b = b

r :: [a] -> [a]
r []     = []
r [x]    = []
r (_:xs) = xs

co :: (b -> c) -> (a -> b) -> a -> c
co bToc aTob a = bToc $ aTob a

a :: (a -> c) -> a -> a
a _ a = a

a' :: (a -> b) -> a -> b
a' aTob a = aTob a
