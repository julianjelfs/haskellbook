module Exercises where

import Control.Monad.Trans.Reader
import Control.Monad.Identity

rDec :: Num a => Reader a a
rDec = do
  v <- ask
  return $ v - 1

rShow :: Show a => ReaderT a Identity String
--rShow = ReaderT $ Identity . show
rShow = do
  v <- ask
  return $ show v