module Main where

import           Control.Monad (forever)
import           Data.Char     (toLower)
import           Data.List     (intersperse)
import           Data.Maybe    (isJust)
import           System.Exit   (exitSuccess)
import           System.Random (randomRIO)

newtype WordList =
  WordList [String]
  deriving (Eq, Show)

allWords :: IO WordList
allWords = do
  dict <- readFile "data/dict.txt"
  return $ WordList (lines dict)

minWordLength :: Int
minWordLength = 4

maxWordLength :: Int
maxWordLength = 7

gameWords :: IO WordList
gameWords = do
  (WordList aw) <- allWords
  return $ WordList (filter suitableLength aw)
  where
    suitableLength w =
      let l = length w
      in l > minWordLength && l < maxWordLength

randomWord :: WordList -> IO String
randomWord (WordList wl) = do
  randomIndex <- randomRIO (0, (length wl) - 1)
  return $ wl !! randomIndex

randomWord' :: IO String
randomWord' = gameWords >>= randomWord

data Puzzle =
  Puzzle String
         [Maybe Char]
         [Char]

instance Show Puzzle where
  show (Puzzle word discovered guessed) =
    (intersperse ' ' $ fmap renderPuzzleChar discovered) ++
    "  Guessed so far: " ++ allGuesses
    where
      allGuesses =
        guessed ++ (correctGuesses discovered)

freshPuzzle :: String -> Puzzle
freshPuzzle w = Puzzle w (map (const Nothing) w) []

charInWord :: Puzzle -> Char -> Bool
charInWord (Puzzle w _ _) c = elem c w

correctGuesses :: [Maybe Char] -> [Char]
correctGuesses discovered =
  foldr
    (\mc res ->
      case mc of
        Just c -> c : res
        Nothing -> res
    ) [] discovered

alreadyGuessed :: Puzzle -> Char -> Bool
alreadyGuessed (Puzzle _ discovered guessed) c =
  (elem c guessed) || (elem c (correctGuesses discovered))

fillInCharacter :: Puzzle -> Char -> Puzzle
fillInCharacter (Puzzle word discovered guessed) c =
  Puzzle word updated newGuessed
  where
    newGuessed =
      if elem c word then
        guessed
      else
        (c : guessed)
    zipper letter slot =
      if letter == c
        then Just c
        else slot
    updated = zipWith zipper word discovered

handleGuess :: Puzzle -> Char -> IO Puzzle
handleGuess puzzle guess = do
  putStrLn $ "Your guess was: " ++ [guess]
  case (charInWord puzzle guess, alreadyGuessed puzzle guess) of
    (_, True) -> do
      putStrLn "You already guessed that character, pick something else!"
      return puzzle

    (True, _) -> do
      putStrLn "This character was in the word - awesome!"
      return $ fillInCharacter puzzle guess

    (False, _) -> do
      putStrLn "Nope, bad luck, try again!"
      return $ fillInCharacter puzzle guess

gameOver :: Puzzle -> IO ()
gameOver (Puzzle word _ guessed) =
  if (length guessed) > 7 then
    do
      putStrLn "You lose!"
      putStrLn $ "The word was: " ++ word
      exitSuccess
  else return ()

gameWin :: Puzzle -> IO ()
gameWin (Puzzle _ discovered _) =
  if all isJust discovered then
    do
      putStrLn "You win!"
      exitSuccess
  else return ()

runGame :: Puzzle -> IO ()
runGame puzzle = forever $ do
  gameOver puzzle
  gameWin puzzle
  putStrLn $ "Current puzzle is " ++ show puzzle
  putStr "Guess a letter: "
  guess <- getLine
  case guess of
    [c] -> handleGuess puzzle c >>= runGame
    _ -> putStrLn "Your guess must be a single character"


renderPuzzleChar :: (Maybe Char) -> Char
renderPuzzleChar (Just c) = c
renderPuzzleChar Nothing  = '_'

main :: IO ()
main = do
  word <- randomWord'
  runGame $ freshPuzzle (fmap toLower word)
