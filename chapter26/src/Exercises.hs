module Exercises where

import Control.Monad.Trans.Reader
import Control.Monad.Trans.State
import Control.Monad.Trans.Maybe
import Control.Monad.Identity
import Control.Monad.IO.Class
import Control.Monad

rDec :: Num a => Reader a a
rDec = do
  v <- ask
  return $ v - 1

rShow :: Show a => ReaderT a Identity String
--don't really get this implementation
--rShow = ReaderT $ Identity . show
rShow = do
  v <- ask
  return $ show v

rPrintAndInc :: (Num a, Show a) => ReaderT a IO a
rPrintAndInc = do
  v <- ask
  liftIO (putStrLn $ "Hi: " ++ show v)
  return $ v + 1

sPrintIncAccum :: (Num a, Show a) => StateT a IO String
sPrintIncAccum = do 
  s <- get
  liftIO (putStrLn $ "Hi: " ++ show s)
  put (s + 1)
  return $ show s
    
isValid :: String -> Bool
isValid v = '!' `elem` v

maybeExcite :: MaybeT IO String
maybeExcite = do
  v <- liftIO getLine 
  guard $ isValid v
  return v

doExcite :: IO ()
doExcite = do
  putStrLn "say something excite!"
  excite <- runMaybeT maybeExcite
  case excite of
    Nothing -> putStrLn "MOAR EXCITE"
    Just e -> 
      putStrLn ("Good, was very excite: " ++ e)
