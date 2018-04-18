{-# LANGUAGE OverloadedStrings #-}

module HitCount where

import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Control.Monad.IO.Class
import Data.IORef
import qualified Data.Map as M
import Data.Maybe (fromMaybe)
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as TL
import System.Environment (getArgs)
import Web.Scotty.Trans

data Config =
  Config {
      counts :: IORef (M.Map Text Integer)
    , prefix :: Text
  }

type Scotty =
  ScottyT Text (ReaderT Config IO)

type Handler =
  ActionT Text (ReaderT Config IO)

bumpBoomp :: Text 
          -> M.Map Text Integer
          -> (M.Map Text Integer, Integer)
bumpBoomp k m = (M.insert k bump m, bump)
  where bump = fromMaybe 0 (M.lookup k m) + 1

app :: Scotty ()
app = 
  get "/:key" $ do
    unprefixed <- param "key"
    config <- lift ask  --don't get why we need to lift this 
    let key' = mappend (prefix config) unprefixed
        ref = counts config
        map' = readIORef ref    --map' :: IO (M.Map Text Integer)
    (newMap, newInteger) <- liftIO (bumpBoomp key' <$> map')
    liftIO $ writeIORef ref newMap

    html $
      mconcat [ "<h1>Success! Count was: "
              , TL.pack $ show newInteger
              , "</h1>"
              ]

main :: IO ()
main = do
  [prefixArg] <- getArgs
  counter <- newIORef M.empty
  let config = Config counter (TL.pack prefixArg) 
      runR r = runReaderT r config
  scottyT 3000 runR app
