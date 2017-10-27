module Palindrom where

import           Control.Monad
import           Data.Char     (toLower)
import           System.Exit   (exitSuccess)

puntuation = [' ', ',', '.', '\'']

removePunctuation = filter (\c -> not $ elem c puntuation)

toLowerCase = fmap toLower

sanitize = toLowerCase . removePunctuation

palindrome =
  forever $ do
    line1 <- fmap sanitize getLine
    case (line1 == reverse line1) of
      True -> putStrLn "It's a palindrome"
      False -> do
        putStrLn "Not a palindrome. Exiting"
        exitSuccess
