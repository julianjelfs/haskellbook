{-# LANGUAGE FlexibleContexts #-}

module Whatever where

import Control.Monad.Trans.Reader
import System.Environment (getArgs)

data Config =
  Config String

tom :: Reader Config String
tom = do
    (Config args) <- ask -- gives you the environment which in this case is a String
    return (args ++ " This is Tom.")

jerry :: Reader Config String
jerry = do
  (Config args) <- ask
  return (args ++ " This is Jerry.")

tomAndJerry :: Reader Config String
tomAndJerry = do
    t <- tom
    j <- jerry
    return (t ++ "\n" ++ j)

runJerryRun :: IO String
runJerryRun = do
  [args] <- getArgs
  return $ (runReader tomAndJerry) (Config args)

main :: IO ()
main = do
  r <- runJerryRun
  putStrLn r
