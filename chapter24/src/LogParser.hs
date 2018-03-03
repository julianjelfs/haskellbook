module LogParser where

import Control.Applicative
import Data.Maybe
import Text.Trifecta

type Day = Int
type Month = Int
type Year = Int
type Hour = Int
type Minute = Int
type Activity = String

data Diary =
  Diary [DiaryDay]
  deriving (Eq, Show)

data DiaryDay =
  DiaryDay Date [Entry]
  deriving (Eq, Show)

data Date =
  Date Day Month Year
  deriving (Eq, Show)

data Entry =
  Entry Time Activity
  deriving (Eq, Show)

data Time =
  Time Hour Minute
  deriving (Eq, Show)

doParse p = parseString p mempty

parse = do
  l <- readFile "data/logdata.txt"
  return $ doParse parseLines l

parseLines =
  sepBy lineParser newline

lineParser =
  many (notChar '\n')

dateParser = do
  _ <- string "# "
  y <- digits 4
  _ <- char '-'
  m <- digits 2
  _ <- char '-'
  d <- digits 2
  return $ Date d m y

commentParser :: Parser String
commentParser =
  string "--" *> some anyChar

timeParser = do
  h <- digits 2
  _ <- char ':'
  m <- digits 2
  return $ Time h m

entryParser = do
  t <- timeParser
  _ <- char ' '
  a <- some (notChar '\n')
  _ <- optional newline
  return $ Entry t a

entriesParser =
  some entryParser

digits :: Int -> Parser Int
digits n = read <$> count n digit

{-

-- whee a comment

# 2025-02-05
08:00 Breakfast
09:00 Sanitizing moisture collector
11:00 Exercising in high-grav gym
12:00 Lunch
13:00 Programming
17:00 Commuting home in rover
17:30 R&R
19:00 Dinner
21:00 Shower
21:15 Read
22:00 Sleep

# 2025-02-07 -- dates not necessarily sequential
08:00 Breakfast -- should I try skipping breakfast
09:00 Bumped head, passed out
13:36 Wake up, headache
13:37 Go to med bay
13:40 Patch self up
13:45 Commute home for rest
14:15 Read
21:00 Dinner
21:15 Read
22:00 Sleep

-}
