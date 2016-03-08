{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

import System.Directory
import Data.List
import Lexer
import Parser
import Ast

main :: IO ()
main = do
  createDirectoryIfMissing True "out"
  inp <- readFile "Concrete Examples/Msg.asn2"
  let tokens = alexScanTokens inp
  let formats = parser tokens
  print formats

  if not $ disjoint formats then
    print "Formats are not disjoint. Leaving"
  else
    writeClasses formats

writeClasses :: [Format] -> IO ()
writeClasses [] = putStr "Done outputting classes."
writeClasses ((Format name _ (Concrete format fields)):xs)
  | format == "XML" = do writeXML name fields
                         writeClasses xs
  | format == "ASN1" = do writeASN1 name fields
                          writeClasses xs

  {-
  do
  imports <- readFile "imports.txt"
  {-
    TODO: Run trough all formats, and create a seperate
          class for each of them
  -}
  let format = head formats
  let fileLines = imports 
                ++ makeHeader format            
  putStr fileLines
  -}

writeXML :: String -> [Field] -> IO ()
writeXML name fields = 
  writeFile ("out/" ++ name ++ ".java") (makeHeader name)

writeASN1 :: String -> [Field] -> IO ()
writeASN1 name fields = print "Test"

makeHeader :: String -> String
makeHeader name = 
                  "public class "
                  ++ name
                  ++ "{\n"