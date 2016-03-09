{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}
import Prelude hiding ((<$>))
import Data.Char (toUpper)
import System.Directory
import Text.PrettyPrint.Leijen
import System.IO
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
writeXML name fields = do
  { handle <- openFile ("out/" ++ name ++ ".java") WriteMode
  ; hPutDoc handle (makeDoc name fields)
  ; hClose handle
  }

makeDoc :: String -> [Field] -> Doc
makeDoc name fields = 
  makeImports <$> 
  nest level
    (makeHeader name <$>
      makeNumNodes fields 0 <$>
      makePrivateVars fields <$>
      makeConstructor fields name

    )

level :: Int
level = 4

writeASN1 :: String -> [Field] -> IO ()
writeASN1 name fields = print "Wow! Also got some ASN1!"


{-

    Doc generators

-}

makeImports :: Doc
makeImports = 
  text "import org.w3c.dom.Document;" <$>
  text "import org.w3c.dom.Node;" <$>
  text "import org.xml.sax.InputSource;" <$>
  text "import javax.xml.parsers.DocumentBuilder;" <$>
  text "import javax.xml.parsers.DocumentBuilderFactory;" <$>
  text "import java.io.StringReader;" <$>
  empty

makeHeader :: String -> Doc
makeHeader name = text $ "public class " ++ capitalized name ++ " {"

makePrivateVars :: [Field] -> Doc
makePrivateVars [] = empty
makePrivateVars ((Field id tag (Encoding enc)):xs)
  | enc == "String" = text "String " <> text id <> text ";" <$> makePrivateVars xs
  | enc == "Base64" = text "byte[] " <> text id <> text ";" <$> makePrivateVars xs
  | otherwise       = error $ 
                        "Failed. Incorrect encoding in: " 
                        ++ tag ++ ": " ++ id ++ "\nExpected String or Base64.\n"
                        ++ "Got: " ++ enc

makeNumNodes :: [Field] -> Int -> Doc
makeNumNodes [] n = text $ "int numNodes = " ++ (show n)
makeNumNodes (x:xs) n = makeNumNodes xs (n+1)

--f x = 2 * f' x * y x
--  where f' a = 2 * a

makeConstructor :: [Field] -> String -> Doc
makeConstructor fields name =
  nest level (
  -- Should be made to doc and not a string
    text ("public " 
          ++ capitalized name 
          ++ "(" 
          ++ makeArgs fields 
          ++ ") throws InvalidInputException {") <$>
      makeAssigns) <$>
  nest level (
    text "}else { " <$> 
      text "throw new InvalidInputException();") <$>
  text "}"
  where makeArgs ([Field id tag (Encoding enc)]) = 
          if enc == "Base64" 
            then "byte[] " ++ id 
            else "String " ++ id
        makeArgs (Field id tag (Encoding enc) : xs) =
          if enc == "Base64" 
            then "byte[] " ++ id ++ "," ++ makeArgs xs
            else "String " ++ id ++ "," ++ makeArgs xs
        makeArgs [] = ""
        makeAssigns = text "something else"
    
capitalized :: String -> String
capitalized (head:tail) = toUpper head : tail
capitalized [] = []