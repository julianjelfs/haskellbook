module Phone where

import           Data.Char
import           Data.List

type Digit = Char

type Presses = Int

type Phone = [(Digit, [Char])]

digits :: Phone
digits =
  [ ('2', ['a', 'b', 'c'])
  , ('3', ['d', 'e', 'f'])
  , ('4', ['g', 'h', 'i'])
  , ('5', ['j', 'k', 'l'])
  , ('6', ['m', 'n', 'o'])
  , ('7', ['p', 'q', 'r', 's'])
  , ('8', ['t', 'u', 'v'])
  , ('9', ['w', 'x', 'y', 'z'])
  , ('*', ['^'])
  , ('0', [' '])
  , ('#', ['.', ','])
  ]

reverseTaps :: Phone -> Char -> [(Digit, Presses)]
reverseTaps phone c
  | isUpper c = ('*', 1 :: Int) : (reverseTaps phone $ toLower c)
  | otherwise =
    [ foldr
        (\(d, cs) res ->
           if d == c
             then (d, (length cs) + 1)
             else case elemIndex c cs of
                    Just i  -> (d, i + 1)
                    Nothing -> res)
        (' ', 0)
        phone
    ]

stringToTaps :: Phone -> String -> [(Digit, Presses)]
stringToTaps phone = foldr (\c res -> (reverseTaps phone c) ++ res) []

convoToTaps :: Phone -> [String] -> [[(Digit, Presses)]]
convoToTaps phone = map (stringToTaps phone)

fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps presses = sum $ map snd presses

convo :: [String]
convo =
  [ "Wanna play 20 questions"
  , "Ya"
  , "U 1st haha"
  , "Lol ok. Have u ever tasted alcohol lol"
  , "Lol ya"
  , "Wow ur cool haha. Ur turn"
  , "OK. Do you think I am pretty Lol"
  , "Lol ya"
  , "Haha thanks just making sure rofl ur turn"
  ]
