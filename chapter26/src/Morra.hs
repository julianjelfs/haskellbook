module Morra where

import System.Random
import Control.Monad.Trans.State
import Control.Monad.IO.Class

data Player = Human | Computer deriving (Show, Eq)

type Scores = (Integer, Integer)

computerTurn :: IO Integer
computerTurn =
  getStdRandom (randomR (1,2))

turn :: StateT Scores IO Player
turn = do
  (h, c) <- get
  h' <- liftIO $ (read::String->Integer) <$> getLine
  c' <- liftIO $ computerTurn
  let w = winner h' c'
  case w of
    Human -> put (h+1, c)
    Computer -> put (h, c+1)
  return w

winner :: Integer -> Integer -> Player
winner p c
  | odd $ p + c = Human 
  | even $ p + c = Computer

play :: IO Scores
play = do
  (w, s) <- runStateT turn (0,0)
  return s
