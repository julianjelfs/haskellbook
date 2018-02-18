module LearnParsers where

import Text.Trifecta
import Text.Parser.Combinators

stop :: Parser a
stop = unexpected "stop"

oneS :: CharParsing m => m String
oneS = string "1"

one = char '1' >> eof

one' = one >> stop

oneTwo = char '1' >> char '2' >> eof

oneTwo' = oneTwo >> stop

testParseS :: Parser String -> IO()
testParseS p =
    print $ parseString p mempty "123"

testParse :: Parser Char -> IO()
testParse p =
    print $ parseString p mempty "123"

testEOF :: Parser () -> IO()
testEOF p =
    print $ parseString p mempty "123"

pNL s = 
    putStrLn ('\n' : s)

main = do
    pNL "stop:"
    testParse stop
    pNL "one:"
    testEOF one
    pNL "one':"
    testParse one'
    pNL "oneTwo:"
    testEOF oneTwo
    pNL "oneTwo':"
    testEOF oneTwo'
    
