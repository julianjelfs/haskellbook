module Person where

type Name = String

type Age = Integer

data Person =
  Person Name
         Age
  deriving (Show)

data PersonInvalid
  = NameEmpty
  | AgeTooLow
  | PersonInvalidUnknown String
  deriving (Show, Eq)

mkPerson :: Name -> Age -> Either PersonInvalid Person
mkPerson name age
  | name /= "" && age > 0 = Right $ Person name age
  | name == "" = Left NameEmpty
  | not (age > 0) = Left AgeTooLow
  | otherwise =
    Left $
    PersonInvalidUnknown $ "Name was: " ++ show name ++ "Age was: " ++ show age

gimmePerson :: IO ()
gimmePerson = do
  putStrLn "Enter age"
  age <- fmap read getLine
  putStrLn "Enter name"
  name <- getLine
  case mkPerson name age of
    Right person -> putStrLn $ "Yay! Successfully got a person: " ++ show person
    Left NameEmpty -> putStrLn "You forgot to enter a name"
    Left AgeTooLow -> putStrLn "Your age is too low"
    Left (PersonInvalidUnknown err) ->
      putStrLn $ "You did something wrong: " ++ err
