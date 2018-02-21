module Fractions where

import Control.Applicative
import Data.Ratio ((%))
import Text.Trifecta

badFraction = "1/0"
alsoBad = "10"
shouldWork = "1/2"
shouldAlsoWork = "2/1"

parseFraction :: Parser Rational
parseFraction = do
  numerator <- decimal
  char '/'
  denominator <- decimal
  return (numerator % denominator)

parseFractionOrDecimal :: Parser (Either Integer Rational)
parseFractionOrDecimal =
   (try (Right <$> parseFraction)) <|> (Left <$> decimal)

justInt = do
  i <- integer
  _ <- eof
  return i

parseJustInt =
  parseString justInt mempty