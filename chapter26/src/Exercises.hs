module Exercises where

import Control.Monad.Trans.Reader
import Control.Monad.Identity
import Control.Monad.IO.Class

rDec :: Num a => Reader a a
rDec = do
  v <- ask
  return $ v - 1

rShow :: Show a => ReaderT a Identity String
--rShow = ReaderT $ Identity . show
rShow = do
  v <- ask
  return $ show v

rPrintAndInc :: (Num a, Show a) => ReaderT a IO a
rPrintAndInc = do
  v <- ask
  liftIO (putStrLn $ "Hi: " ++ show v)
  return $ v + 1