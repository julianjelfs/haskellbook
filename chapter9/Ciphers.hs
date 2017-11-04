module Ciphers where

import           Data.Char

applyOffset :: Int -> Int
applyOffset n = mod n 26

offsetChar :: Int -> Char -> Char
offsetChar _ ' '    = ' '
offsetChar offset c = chr $ (+ 97) $ applyOffset $ ((ord c) - 97) + offset

caesar :: String -> String
caesar str = map (offsetChar 3) str

uncaesar :: String -> String
uncaesar str = map (offsetChar (-3)) str

main :: IO ()
main = do
  inp <- getLine
  putStrLn $ caesar inp
