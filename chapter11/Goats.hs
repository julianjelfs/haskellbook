{-# LANGUAGE FlexibleInstances #-}
module Goats where

class TooMany a where
  tooMany :: a -> Bool

instance TooMany Int where
  tooMany n = n > 42

instance TooMany Goats where
  tooMany (Goats n) = n > 10

instance TooMany (Int, String) where
  tooMany (n, _) = n > 20

instance TooMany (Int, Int) where
  tooMany (n1, n2) = (n1 + n2) > 20

instance (TooMany a) => TooMany (a, a) where
  tooMany (n1, n2) = tooMany n2 || tooMany n1

newtype Goats =
  Goats Int deriving (Eq, Show)