module SemVerParser where

import Control.Applicative
import Data.Maybe
import Text.Trifecta

--Write a parser that follows the spec at http://semver.org
--2.0.0  2.0.0-rc.1+exp.s.234.whatevs
-- release follows patch and is - followed by [numorstring]
-- meta follows patch or release and is + followed by [numorstring]
data NumberOrString
  = NOSS String
  | NOSI Integer
  deriving (Eq, Show)

type Major = Integer

type Minor = Integer

type Patch = Integer

type Release = [NumberOrString]

type Metadata = [NumberOrString]

data SemVer =
  SemVer Major
         Minor
         Patch
         Release
         Metadata
  deriving (Show, Eq)

instance Ord SemVer where
  compare (SemVer maj1 min1 p1 _ _) (SemVer maj2 min2 p2 _ _)
    | maj1 /= maj2 = compare maj1 maj2
    | min1 /= min2 = compare min1 min2
    | p1 /= p2 = compare p1 p2
    | otherwise = EQ

integerParser :: Parser Integer
integerParser = do
  d <- some digit
  return $ read d

numOrStringParser :: Parser NumberOrString
numOrStringParser = (NOSI <$> integerParser) <|> (NOSS <$> some alphaNum)

-- release follows patch and is - followed by [numorstring]
releaseParser :: Parser Release
releaseParser = char '-' >> sepBy numOrStringParser (char '.')

metaParser :: Parser Metadata
metaParser = char '+' >> sepBy numOrStringParser (char '.')

parserSemVer :: Parser SemVer
parserSemVer = do
  maj <- integerParser
  char '.'
  min <- integerParser
  char '.'
  patch <- integerParser
  release <- optional releaseParser
  meta <- optional metaParser
  return $ SemVer maj min patch (fromMaybe [] release) (fromMaybe [] meta)

doParse p = parseString p mempty

main = do
  print $ doParse parserSemVer "2.1.1"
  print $ doParse parserSemVer "1.0.0-x.7.z.92"
