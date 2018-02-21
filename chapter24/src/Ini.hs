{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Ini where

import Control.Applicative
import Data.ByteString (ByteString)
import Data.Char (isAlpha)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Text (Text)
import qualified Data.Text.IO as TIO
import Test.Hspec
import Text.RawString.QQ
import Text.Trifecta

headerEx :: ByteString
headerEx = "[blah]"

assignmentEx :: ByteString
assignmentEx = "woot=1"

commentEx :: ByteString
commentEx =
  "; last modified 1 April\
  \ 2001 by Jon Doe"

commentEx' :: ByteString
commentEx' =
  "; blah\n; woot\n \n;hah"

sectionEx :: ByteString
sectionEx =
  "; ignore me\n[states]\nChris=Texas"

sectionEx' :: ByteString
sectionEx' = [r|
; ignore me
[states]
Chris=Texas
|]

sectionEx'' :: ByteString
sectionEx'' = [r|
; comment
[section]
host=wikipedia.org
alias=claw

[whatisit]
red=intoothandclaw
|]

type Name = String
type Value = String
type Assignments = Map Name Value

data Section =
  Section Header Assignments
  deriving (Eq, Show)

newtype Config =
  Config (Map Header Assignments)
  deriving (Eq, Show)

skipWhitespace :: Parser ()
skipWhitespace =
  skipMany (char ' ' <|> char '\n')

rollup :: Section -> Map Header Assignments -> Map Header Assignments
rollup (Section h a) m =
  M.insert h a m

parseIni :: Parser Config
parseIni = do
  sections <- some parseSection
  let mapOfSections =
        foldr rollup M.empty sections
  return (Config mapOfSections)

parseSection :: Parser Section
parseSection = do
  skipWhitespace
  skipComments
  h <- parseHeader
  skipEOL
  assigments <- some parseAssignment
  return $ Section h (M.fromList assigments)


parseAssignment :: Parser (Name, Value)
parseAssignment = do
  name <- some letter
  _ <- char '='
  val <- some (noneOf "\n")
  skipEOL
  return (name, val)

skipEOL :: Parser ()
skipEOL = skipMany (oneOf "\n")

skipComments :: Parser ()
skipComments =
  skipMany comment
  where comment = do
          _ <- char ';' <|> char '#'
          skipMany (noneOf "\n")
          skipEOL

newtype Header =
  Header String
  deriving (Eq, Ord, Show)

parseBracketPair :: Parser a -> Parser a
parseBracketPair p = char '[' *> p <* char ']'

parseHeader :: Parser Header
parseHeader =
  parseBracketPair (Header <$> some letter)
