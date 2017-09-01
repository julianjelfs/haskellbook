module Compose where

tensDigit :: Integral a => a -> a
tensDigit x = d
    where
        (a, _) = x `divMod` 10
        d = a `mod` 10

foldBool1 :: a -> a -> Bool -> a
foldBool1 x y True = x
foldBool1 x y False = y

foldBool2 :: a -> a -> Bool -> a
foldBool2 x y b =
    case b of
        True -> x
        False -> y

foldBool3 :: a -> a -> Bool -> a
foldBool3 x y b
    | b = x
    | otherwise = y

g :: (a->b) -> (a,c) -> (b,c)
g atob (a,c) =
    (atob a, c)


roundTrip :: (Show a, Read b) => a -> b
roundTrip = read . show

main = do
    print ((roundTrip 4) :: Int)
    print (id 4)

