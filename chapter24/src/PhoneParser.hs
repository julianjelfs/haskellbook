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

parsePhone :: Parser PhoneNumber
parsePhone = undefined
