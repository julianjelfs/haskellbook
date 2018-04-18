module Morra where

import System.Random
import Control.Monad.Trans.State
import Control.Monad.IO.Class
import System.Exit   (exitSuccess)
import Control.Monad (forever)


data Player = Human | Computer deriving (Show, Eq)
data Winner = HumanWins | ComputerWins | NeitherWins

type Scores = (Integer, Integer)

computerTurn :: IO Integer
computerTurn =
  getStdRandom (randomR (1,5))

humanTurn :: IO Integer
humanTurn = do
  putStrLn "Enter a number from 1 to 5"
  h <- (read::String->Integer) <$> getLine
  if validInput h 
  then return h
  else humanTurn
  where validInput x = x > 0 && x < 6
  

turn :: StateT Scores IO Player
turn = do
  (h, c) <- get
  h' <- liftIO humanTurn
  c' <- liftIO computerTurn
  let w = turnWinner h' c'
  case w of
    Human -> put (h+1, c)
    Computer -> put (h, c+1)
  return w

turnWinner :: Integer -> Integer -> Player
turnWinner p c
  | odd $ p + c = Human 
  | even $ p + c = Computer

play :: IO Scores
play = do
  (w, s) <- runStateT turn (0,0)
  return s

gameWinner :: Scores -> Winner
gameWinner (h, c)
  | h > 5 = HumanWins
  | c > 5 = ComputerWins
  | otherwise = NeitherWins

main :: IO ()
main = 
  forever $ do
    scores <- play
    case gameWinner scores of
      HumanWins -> do
        putStrLn "Human Wins"
        exitSuccess
      ComputerWins -> do
        putStrLn "Computer Wins"
        exitSuccess
      _ -> putStrLn $ "On we go..." ++ show scores

