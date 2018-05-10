{-# LANGUAGE OverloadedStrings #-}

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
import Database.SQLite.Simple hiding (bind, close)
import qualified Database.SQLite.Simple as SQLite
import Database.SQLite.Simple.Types
import Network.Socket hiding (recv)
import Network.Socket.ByteString (recv, sendAll)

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

handleQuery :: Connection -> Socket -> IO ()
handleQuery conn soc = do
  msg <- recv soc 1024
  case msg of
    "\r\n" -> returnUsers conn soc
    name -> returnUser conn soc (decodeUtf8 name)

handleQueries :: Connection -> Socket -> IO ()
handleQueries conn sock =
  forever $ do
    (soc, _) <- accept sock
    putStrLn "Got connection, handling query"
    handleQuery conn soc
    close soc

main :: IO ()
main =
  withSocketsDo $ do
    addrinfos <-
      getAddrInfo
        (Just (defaultHints {addrFlags = [AI_PASSIVE]}))
        Nothing
        (Just "79")
    let serveraddr = head addrinfos
    sock <- socket (addrFamily serveraddr) Stream defaultProtocol
    bind sock (addrAddress serveraddr)
    listen sock 1
    conn <- open "finger.db"
    handleQueries conn sock
    close sock
