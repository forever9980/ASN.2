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

writeXML :: String -> [Field] -> IO ()
writeXML name fields = 
  writeFile ("out/" ++ name ++ ".java") $ (makeHeader name) ++ makePrivateVars fields

writeASN1 :: String -> [Field] -> IO ()
writeASN1 name fields = print "Test"


-- Current WIP
makePrivateVars :: [Field] -> String
makePrivateVars [] = "\n"
makePrivateVars ((Field id tag (Encoding enc)):xs)
  | enc == "String" = "String "
  | enc == "Base64" = "test "
  otherwise "Wrong encoding in: "


makeHeader :: String -> String
makeHeader name = 
                  "public class "
                  ++ name
                  ++ "{\n"
                  ++ "int numNodes = "