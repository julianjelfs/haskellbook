module SemVerParser where

import Text.Trifecta
import Data.Maybe

--Write a parser that follows the spec at http://semver.org
--2.0.0  2.0.0-rc.1+exp.s.234.whatevs
-- release follows patch and is - followed by [numorstring]
-- meta follows patch or release and is + followed by [numorstring]

data NumberOrString
  = NOSS String
  | NOSI Integer
  deriving Show

type Major = Integer

type Minor = Integer

type Patch = Integer

type Release = [NumberOrString]

type Metadata = [NumberOrString]

data SemVer =
  SemVer Major Minor Patch Release Metadata
  deriving Show

integerParser :: Parser Integer
integerParser = do
  d <- some digit
  return $ read d

releaseParser :: Parser Release
releaseParser = pure [NOSS "release"]

metaParser :: Parser Metadata
metaParser = pure [NOSS "meta"]

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

doParse p =
  parseString p mempty
