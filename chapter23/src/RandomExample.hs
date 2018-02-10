module RandomExample where

import Control.Applicative (liftA3)
import Control.Monad (replicateM)
import Control.Monad.Trans.State
import System.Random

data Die
  = DieOne
  | DieTwo
  | DieThree
  | DieFour
  | DieFive
  | DieSix
  deriving (Eq, Show)

rollDie :: State StdGen Die
rollDie = intToDie <$> state (randomR (1, 6))

rollDieThreeTimes :: State StdGen (Die, Die, Die)
rollDieThreeTimes = (,,) <$> rollDie <*> rollDie <*> rollDie

infiniteDie :: State StdGen [Die]
infiniteDie = repeat <$> rollDie

nDie :: Int -> State StdGen [Die]
nDie n = replicateM n rollDie

intToDie :: Int -> Die
intToDie n =
  case n of
    1 -> DieOne
    2 -> DieTwo
    3 -> DieThree
    4 -> DieFour
    5 -> DieFive
    6 -> DieSix
    x -> error $ "intToDie got non 1-6 int: " ++ show x

rollsToGetTwenty :: StdGen -> Int
rollsToGetTwenty g = go 0 0 g
  where
    go :: Int -> Int -> StdGen -> Int
    go sum count gen
      | sum >= 20 = count
      | otherwise =
        let (die, nextGen) = randomR (1, 6) gen
        in go (sum + die) (count + 1) nextGen

rollsToGetN :: Int -> StdGen -> (Int, [Die])
rollsToGetN n g = go 0 0 g []
  where
    go :: Int -> Int -> StdGen -> [Die] -> (Int, [Die])
    go sum count gen series
      | sum >= n = (count, reverse series)
      | otherwise =
        let (die, nextGen) = randomR (1, 6) gen
        in go (sum + die) (count + 1) nextGen ((intToDie die) : series)

newtype Moi s a = Moi
  { runMoi :: s -> (a, s)
  }

instance Functor (Moi s) where
  fmap f (Moi g) =
    Moi $ \s ->
      let (a, s1) = g s
      in (f a, s1)

instance Applicative (Moi s) where
  pure a = Moi $ \s -> (a, s)

  (Moi f) <*> (Moi g) =
    Moi $ \s ->
      let (atob, s1) = f s
          (a, s2) = g s1
      in (atob a, s2)

instance Monad (Moi s) where
  return = pure

  (Moi f) >>= g =
    Moi $ \s ->
        let (a, s1) = f s
            b = runMoi $ g a
        in b s1

main :: IO()
main =
  mapM_ (putStrLn . show) [1..100]
