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
import MakeXMLDoc hiding(level)
import MakeASNDoc hiding(level)

level :: Int
level = 2

main :: IO ()
main = do
  createDirectoryIfMissing True "out"
  inp <- readFile "Concrete Examples/Msg.asn2"
  let tokens = alexScanTokens inp
  let formats = parser tokens
{-
  if not $ disjoint formats then
    print "Formats are not disjoint. Leaving"
  else -}
  writeClasses formats

writeClasses :: [Format] -> IO ()
writeClasses [] = putStr "Done outputting classes."
writeClasses ((Format name (XML format fields)):xs) 
  = do writeXML name fields
       writeClasses xs
writeClasses ((Format name (ASN format fields)):xs) 
  = do writeASN1 name fields
       writeClasses xs

writeASN1 :: String -> [Field] -> IO ()
writeASN1 name fields = do 
  { handle <- openFile ("out/" ++ name ++ "_ASN" ++ ".java") WriteMode
    ; hPutDoc handle (makeASNDoc (name ++ "_ASN") fields)
    ; hClose handle
  }

writeXML :: String -> [Field] -> IO ()
writeXML name fields = do
  {-if hasValidTags fields
    then do -}
      { handle <- openFile ("out/" ++ name ++ "_XML" ++ ".java") WriteMode
      ; hPutDoc handle (makeXMLDoc (name ++ "_XML") fields)
      ; hClose handle
      }
    {-else error "Tags contain invalid characters"-}

makeASNDoc :: String -> [Field] -> Doc
makeASNDoc name fields =
  MakeASNDoc.makeImports <$>
  nest level
  (MakeASNDoc.makeHeader name <$>
    MakeASNDoc.makeByteObjClass <$>
    MakeASNDoc.makeNumNodes fields 0 <$>
    MakeASNDoc.makePrivateVars fields
  )

makeXMLDoc :: String -> [Field] -> Doc
makeXMLDoc name fields = 
  MakeXMLDoc.makeImports <$> 
  nest level
  (MakeXMLDoc.makeHeader name <$>
    MakeXMLDoc.makeNumNodes fields 0 <$>
    MakeXMLDoc.makePrivateVars fields <$>
    MakeXMLDoc.makeConstructor fields name <$>
    MakeXMLDoc.makeEncode fields name <$>
    MakeXMLDoc.makePrivateMethods <$>
    MakeXMLDoc.makeGettersAndSetters fields
  )<$>
  text "}"  