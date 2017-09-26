module Folds where

import           Data.Time

data DatabaseItem
  = DbString String
  | DbNumber Integer
  | DbDate UTCTime
  deriving (Eq, Ord, Show)

theDatabase :: [DatabaseItem]
theDatabase =
  [ DbDate (UTCTime (fromGregorian 1911 5 1) (secondsToDiffTime 34123))
  , DbNumber 9001
  , DbNumber 100
  , DbString "Hello, world!"
  , DbDate (UTCTime (fromGregorian 1921 5 1) (secondsToDiffTime 34123))
  ]

mostRecent :: [DatabaseItem] -> UTCTime
mostRecent =
  maximum . getTimes

sumDb :: [DatabaseItem] -> Integer
sumDb =
  sum . filterDbNumber

avgDb :: [DatabaseItem] -> Double
avgDb db =
  (fromIntegral $ sumDb db) / (fromIntegral $ length $ filterDbNumber db)

getTimes :: [DatabaseItem] -> [UTCTime]
getTimes db =
  foldr (\a b ->
    case a of
      DbDate t -> t : b
      _ -> b
  ) [] db

filterDbNumber :: [DatabaseItem] -> [Integer]
filterDbNumber db =
  foldr (\a b ->
    case a of
      DbNumber n -> n : b
      _ -> b
  ) [] db
