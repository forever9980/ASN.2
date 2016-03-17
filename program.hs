{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

import Prelude hiding ((<$>))
import System.Directory
import Text.PrettyPrint.Leijen
import System.IO
import Data.List
import Lexer
import Parser
import Ast
import MakeDoc

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
writeClasses ((Format name _ (XML format fields)):xs) 
  = do writeXML name fields
       writeClasses xs
writeClasses ((Format name _ (ASN format fields)):xs) 
  = do writeASN1 name fields
       writeClasses xs

writeASN1 :: String -> [Field] -> IO ()
writeASN1 name fields = print "Wow! Also got some ASN1!"

writeXML :: String -> [Field] -> IO ()
writeXML name fields = do
  if hasValidTags fields
    then do
      { handle <- openFile ("out/" ++ name ++ "_XML" ++ ".java") WriteMode
      ; hPutDoc handle (makeDoc (name ++ "_XML") fields)
      ; hClose handle
      }
    else error "Tags contain invalid characters"

makeDoc :: String -> [Field] -> Doc
makeDoc name fields = 
  makeImports <$> 
  nest level
  (makeHeader name <$>
    makeNumNodes fields 0 <$>
    makePrivateVars fields <$>
    makeConstructor fields name <$>
    makeEncode fields name <$>
    makePrivateMethods <$>
    makeGettersAndSetters fields
  )<$>
  text "}"  