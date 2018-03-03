module PhoneParser where

import Control.Applicative
import Data.Maybe
import Text.Trifecta

doParse p = parseString p mempty

type NumberingPlanArea = Int
type Exchange = Int
type LineNumber = Int

data PhoneNumber =
  PhoneNumber NumberingPlanArea Exchange LineNumber
  deriving (Eq, Show)

intParser :: Parser Int
intParser = do
  d <- some digit
  return $ read d

digits :: Int -> Parser Int
digits n = read <$> count n digit

parsePhone :: Parser PhoneNumber
parsePhone =
  PhoneNumber <$> npaParser <*> exchangeParser <*> lineParser

npaParser :: Parser NumberingPlanArea
npaParser =
  choice
    [ try $ digits 1 *> char '-' *> digits 3 <* (optional (char '-'))
    , digits 3 <* (optional (char '-'))
    , char '(' *> digits 3 <* string ") "
    ]

exchangeParser :: Parser Exchange
exchangeParser = digits 3 <* (optional (char '-'))

lineParser :: Parser LineNumber
lineParser = digits 4

main = do
  print $ doParse parsePhone "123-456-7890"
  print $ doParse parsePhone "1234567890"
  print $ doParse parsePhone "(123) 456-7890"
  print $ doParse parsePhone "1-123-456-7890"
