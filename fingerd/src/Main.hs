{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import Control.Exception
import Control.Monad (forever)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.List (intersperse)
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Encoding (decodeUtf8, encodeUtf8)
import Data.Typeable
import Database.SQLite.Simple hiding (close)
import qualified Database.SQLite.Simple as SQLite
import Database.SQLite.Simple.Types
import Network.Socket hiding (close, recv)
import Network.Socket.ByteString (recv, sendAll)
import Text.RawString.QQ

data User = User
  { userId :: Integer
  , username :: Text
  , shell :: Text
  , homeDirectory :: Text
  , realName :: Text
  , phone :: Text
  } deriving (Eq, Show)

instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field <*> field <*> field

instance ToRow User where
  toRow (User id_ username shell homeDir realName phone) =
    toRow (id_, username, shell, homeDir, realName, phone)

createUsers :: Query
createUsers =
  " CREATE TABLE IF NOT EXISTS users \
  \  (id INTEGER PRIMARY KEY AUTOINCREMENT, \
  \  username TEXT UNIQUE, \
  \  shell TEXT, \
  \  homeDirectory TEXT, \
  \  realName TEXT, \
  \  phone TEXT)"

insertUser :: Query
insertUser = "INSERT INTO users values (?, ?, ?, ?, ?, ?)"

allUsers :: Query
allUsers = "SELECT * from users"

getUserQuery :: Query
getUserQuery = "SELECT * from users where username = ?"

data DuplicateData =
  DuplicateData
  deriving (Eq, Show, Typeable)

instance Exception DuplicateData

type UserRow = (Null, Text, Text, Text, Text, Text)

getUser :: Connection -> Text -> IO (Maybe User)
getUser conn username = do
  results <- query conn getUserQuery (Only username)
  case results of
    [] -> return Nothing
    [user] -> return $ Just user
    _ -> throwIO DuplicateData

createDatabase :: IO ()
createDatabase = do
  conn <- open "finger.db"
  execute_ conn createUsers
  execute conn insertUser meRow
  rows <- query_ conn allUsers
  mapM_ print (rows :: [User])
  SQLite.close conn
  where
    meRow :: UserRow
    meRow =
      ( Null
      , "jjelfs"
      , "/bin/fish"
      , "/home/jjelfs"
      , "Julian Jelfs"
      , "07867-538-921")

returnUsers :: Connection -> Socket -> IO ()
returnUsers conn soc = do
  rows <- query_ conn allUsers
  let usernames = username <$> rows
      newlineSeparated = T.concat $ intersperse "\n" usernames
  sendAll soc (encodeUtf8 newlineSeparated)

formatUser :: User -> ByteString
formatUser (User _ username shell homeDir realName _) =
  BS.concat
    [ "Login: "
    , e username
    , "\t\t\t\t"
    , "Name: "
    , e realName
    , "\n"
    , "Directory: "
    , e homeDir
    , "\t\t\t"
    , "Shell: "
    , e shell
    , "\n"
    ]
  where
    e = encodeUtf8

returnUser :: Connection -> Socket -> Text -> IO ()
returnUser conn soc username = do
  maybeUser <- getUser conn (T.strip username)
  case maybeUser of
    Nothing -> do
      putStrLn $ "Couldn't find matching user for username: " ++ show username
      pure ()
    Just user -> sendAll soc (formatUser user)

main :: IO ()
main = putStrLn "hello world"
