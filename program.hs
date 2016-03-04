import Lexer
import Parser
import Ast

main :: IO ()
main = do
  inp <- readFile "testinput.xml"
  let tokens = alexScanTokens inp
  let formats = parser tokens
  print (parser tokens)
  print $ disjoint formats

