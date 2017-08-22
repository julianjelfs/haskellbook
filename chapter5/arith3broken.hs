module Arith3Broken where

main :: IO ()
main = do
    print $ 1 + 2
    putStrLn $ show 10
    print (negate (-1))
    print ((+1) blah)
    where blah = negate 1