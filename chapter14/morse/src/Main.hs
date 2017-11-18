module Main where

import           Control.Monad      (forever, when)
import           Data.List          (intercalate)
import           Data.Traversable   (traverse)
import           Morse              (morseToChar, stringToMorse)
import           System.Environment (getArgs)
import           System.Exit        (exitFailure, exitSuccess)
import           System.IO          (hGetLine, hIsEOF, stdin)

main :: IO ()
main = do
  mode <- getArgs
  case mode of
    [arg] ->
      case arg of
        "from" -> convertFromMorse
        "to"   -> convertToMorse
        _      -> argError
    _ -> argError
  where
    argError = do
      putStrLn "Please provide from or to"
      exitFailure

convertToMorse :: IO ()
convertToMorse =
  forever $ do
    weAreDone <- hIsEOF stdin
    when weAreDone exitSuccess
    line <- hGetLine stdin
    convertLine line
  where
    convertLine line = do
      let morse = stringToMorse line
      case morse of
        (Just str) -> putStrLn (intercalate " " str)
        Nothing -> do
          putStrLn "What is going wrong"
          putStrLn $ "ERROR: " ++ line
          exitFailure

convertFromMorse :: IO ()
convertFromMorse =
  forever $ do
    weAreDone <- hIsEOF stdin
    when weAreDone exitSuccess
    line <- hGetLine stdin
    convertLine line
  where
    convertLine line = do
      let decoded :: Maybe String
          decoded = traverse morseToChar (words line)
      case decoded of
        (Just s) -> putStrLn s
        Nothing -> do
          putStrLn $ "ERROR: " ++ line
          exitFailure