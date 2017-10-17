module MyMaybe where

isJust :: Maybe a -> Bool
isJust (Just _) = True
isJust _ = False

isNothing :: Maybe a -> Bool
isNothing = not . isJust

mayybee :: b -> (a -> b) -> Maybe a -> b
mayybee b _ Nothing = b
mayybee b atob (Just a) = atob a

fromMaybe :: a -> Maybe a -> a
fromMaybe def Nothing = def
fromMaybe _ (Just a) = a

listToMaybe :: [a] -> Maybe a
listToMaybe [] = Nothing
listToMaybe (x:_) = Just x

maybeToList :: Maybe a -> [a]
maybeToList (Just a) = [a]
maybeToList Nothing = []

catMaybes :: [Maybe a] -> [a]
catMaybes =
  foldr
    (\x res ->
      case x of
        Just a -> a : res
        Nothing -> res
    ) []

flipMaybe :: [Maybe a] -> Maybe [a]
flipMaybe =
  foldr
    (\m res ->
      case (m, res) of
        (Just m, Just res) -> Just (m : res)
        _ -> Nothing
    ) (Just [])
