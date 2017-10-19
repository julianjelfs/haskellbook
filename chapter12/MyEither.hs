module MyEither where

lefts :: [Either a b] -> [a]
lefts =
  foldr
    (\x res ->
       case x of
         Left a  -> a : res
         Right _ -> res)
    []

rights :: [Either a b] -> [b]
rights =
  foldr
    (\x res ->
       case x of
         Right a -> a : res
         Left _  -> res)
    []

partitionEithers :: [Either a b] -> ([a], [b])
partitionEithers =
  foldr
    (\x (l, r) ->
       case x of
         Left a  -> (a : l, r)
         Right b -> (l, b : r))
    ([], [])

eitherMaybe :: (b -> c) -> Either a b -> Maybe c
eitherMaybe _ (Left _)    = Nothing
eitherMaybe b2c (Right b) = Just $ b2c b

myEither :: (a -> c) -> (b -> c) -> Either a b -> c
myEither a2c _ (Left a)  = a2c a
myEither _ b2c (Right b) = b2c b

eitherMaybe2 :: (b -> c) -> Either a b -> Maybe c
eitherMaybe2 b2c = myEither (\a -> Nothing) (Just . b2c)
