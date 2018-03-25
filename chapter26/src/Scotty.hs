{-# LANGUAGE OverloadedStrings #-}

module Scotty where

import Web.Scotty
import Data.Monoid (mconcat)
import Control.Monad.Trans.Class
import Control.Monad.IO.Class

main = scotty 3000 $ do
  get "/:word" $ do
    beam <- param "word"
    liftIO $ putStrLn "hello"
    html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]

