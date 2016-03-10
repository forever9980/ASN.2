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

level :: Int
level = 2

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
  text "import java.io.ByteArrayInputStream;" <$>
  text "import java.io.StringReader;" <$>
  text "import java.util.Base64;" <$>
  empty

makeHeader :: String -> Doc
makeHeader name = text $ "public class " ++ capitalized name ++ " {"

makePrivateVars :: [Field] -> Doc
makePrivateVars [] = empty
makePrivateVars ((Field id tag (Encoding enc)):xs)
  = text "private byte[] " <> text id <> text ";" <$> makePrivateVars xs

makeNumNodes :: [Field] -> Int -> Doc
makeNumNodes [] n = text $ "private int numNodes = " ++ (show n)
makeNumNodes (x:xs) n = makeNumNodes xs (n+1)

--f x = 2 * f' x * y x
--  where f' a = 2 * a

makeConstructor :: [Field] -> String -> Doc
makeConstructor fields name =
  -- First Constructor
  nest level (
  text ("public " ++ capitalized name ++ "(" ++ makeArgs fields ++ ") throws InvalidInputException {") <$>
    nest level (
    (text "if(" <+> makeIfs fields) <$>
      makeAssigns fields
    ) <$>
    nest level (
    text "}else { " <$> 
      text "throw new InvalidInputException();"
    ) <$>
    text "}"
  ) <$>
  text "}" <$>
  empty <$>
  -- Second Constructor
  nest level (
  text ("public " ++ capitalized name ++ "(byte[] format) throws Exception {") <$>
    text ("Document document = loadXMLFromString(format);") <$>
    text ("Node node = document.getDocumentElement().getFirstChild();") <$>
    text ("if(node.getNodeType()==3) { node = node.getNextSibling(); }") <$>
    nest level (
    text ("for (int i = 1; i<=numNodes; i++){") <$>
      nest level (
      text ("switch(i){") <$>
        makeCases 1 fields
      ) <$>
      text "}" <$>
      text "node = node.getNextSibling().getNextSibling();"
    ) <$>
    text "}"
  ) <$>
  text "}" <$>
  empty

  where makeArgs [Field id tag (Encoding enc)] 
          = "byte[] " ++ id 
        makeArgs (Field id tag (Encoding enc) : xs) 
          = "byte[] " ++ id ++ "," ++ makeArgs xs
        makeAssigns [Field id tag (Encoding enc)] 
          = text $ "this." ++ id ++ " = " ++ id ++ ";"
        makeAssigns (Field id tag (Encoding enc) : xs) 
          = text ("this." ++ id ++ " = " ++ id ++ ";") 
          <$> makeAssigns xs
        makeIfs [Field id tag (Encoding enc)]
          = text $ "isValidInput(" ++ id ++ ") ){"
        makeIfs (Field id tag (Encoding enc) :xs)
          = text ("isValidInput(" ++ id ++ ") && ") <+> makeIfs xs
        makeCases n [Field id tag (Encoding enc)] 
          = text ("case " ++ (show n) ++ ": this." ++ id ++ " = b64decode(node.getTextContent().getBytes); break;")
        makeCases n (Field id tag (Encoding enc) :xs)
          = text ("case " ++ (show n) ++ ": this." ++ id ++ " = b64decode(node.getTextContent().getBytes); break;")
            <$> makeCases (n+1) xs

makeEncode :: [Field] -> String -> Doc
makeEncode fields name =
  nest level(
  text ("public byte[] encode() {") <$>
    nest level(
    text ("return") <$>
      text ("(\"<" ++ name ++ ">\"") <$>
      makeFields fields <$>
      text ("+ \"</" ++ name ++ ">\").getBytes;")
    )
  )<$>
  text "}" <$>
  empty
  
  where makeFields [Field id tag (Encoding enc)]
          = text $ "+ \"  " ++ "<" ++ tag ++ ">\" + new String(b64encode(" ++ id ++ ")) + \"</" ++ tag ++ ">\""
        makeFields (Field id tag (Encoding enc) : xs)
          = text ("+ \"  " ++ "<" ++ tag ++ ">\" + new String(b64encode(" ++ id ++ ")) + \"</" ++ tag ++ ">\"")
            <$> makeFields xs

makePrivateMethods :: Doc
makePrivateMethods =
  nest level(
  text "private byte[] b64encode(byte[] b){" <$>
    text "return Base64.getEncoder().encode(b);"
  )<$>
  text "}" <$>
  nest level(
  text "private byte[] b64decode(byte[] b){" <$>
    text "return Base64.getDecoder().decode(b);"
  )<$>
  text "}" <$>
  nest level(
  text "private boolean isValidInput(byte[] byes){" <$>
    nest level(
    text "for(byte b : bytes {" <$>
      text "if (b==60) return false;"
    ) <$>
    text "return true;"
  )<$>
  text "}" <$>
  nest level(
  text "private static Document loadXML(byte[] xml) throws Exception {" <$>
    text "DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();" <$>
    text "DocumentBuilder builder = factory.newDocumentBuilder();" <$>
    text "return builder.parse(new ByteArrayInputStream(xml));"
  )<$>
  text "}" <$>
  empty

makeGettersAndSetters :: [Field] -> Doc
makeGettersAndSetters [Field id tag (Encoding enc)]
  = text ("public byte[] get" ++ id ++ "(){ return" ++ id ++ "; }")
  <$> text ("public void set" ++ id ++ "(byte[] " ++ id ++ "){ this."
    ++ id ++ " = isValidInput(" ++ id ++ ") ? " ++ id ++ " : " 
    ++ "this." ++ id ++ "; }")
makeGettersAndSetters (Field id tag (Encoding enc) : xs)
  = text ("public byte[] get" ++ id ++ "(){ return" ++ id ++ "; }")
  <$> text ("public void set" ++ id ++ "(byte[] " ++ id ++ "){ this."
    ++ id ++ " = isValidInput(" ++ id ++ ") ? " ++ id ++ " : " 
    ++ "this." ++ id ++ "; }")
  <$> makeGettersAndSetters xs

capitalized :: String -> String
capitalized (head:tail) = toUpper head : tail
capitalized [] = []