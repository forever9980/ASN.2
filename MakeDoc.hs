{-
    XML Doc generators
-}
module MakeDoc where
import Prelude hiding ((<$>))
import Data.Char (toUpper)
import Text.PrettyPrint.Leijen
import Ast

level :: Int
level = 2

makeImports :: FormatBody -> Doc
makeImports (XML _) = 
  text "import org.w3c.dom.Document;" <$>
  text "import org.w3c.dom.Node;" <$>
  text "import org.xml.sax.InputSource;" <$>
  text "import javax.xml.parsers.DocumentBuilder;" <$>
  text "import javax.xml.parsers.DocumentBuilderFactory;" <$>
  text "import java.io.ByteArrayInputStream;" <$>
  text "import java.io.StringReader;" <$>
  text "import java.util.Base64;" <$>
  empty
makeImports (ASN1 _) =
  text "import java.nio.ByteBuffer;" <$>
  empty

makeHeader :: String -> Doc
makeHeader name = text $ "public class " ++ capitalized name ++ " {"

makePrivateVars :: FormatBody -> Doc
makePrivateVars (XML []) = empty
makePrivateVars (ASN1 []) = empty
makePrivateVars (XML (field:fields))
  = text "private byte[] "
makePrivateVars (ASN1 ((Byte _):fields))
  = makePrivateVars (ASN1 fields)
makePrivateVars (ASN1 ((Fixed id length):fields))
  = text ("private ByteObj " ++ id ++ "= new ByteObj (new byte[] {" ++ show length ++ "});") <$>
    makePrivateVars (ASN1 fields)
makePrivateVars (ASN1 ((LengthF id length):fields))
  = text ("private ByteObj " ++ id ++ "= new ByteObj (new byte[] [" ++ show length ++ "]);") <$>
    makePrivateVars (ASN1 fields)
makePrivateVars _ = error "Unsupported field" 

makeConstructor1 :: String -> FormatBody -> Doc
makeConstructor1 name (ASN1 fields) =
  -- First Constructor
  nest level (
  text ("public " ++ capitalized name ++ "(") <+> makeArgs (stripBytes fields) <+> text (") throws InvalidInputException {") <$>
    makeIfs (stripBytes fields)
  ) <$>
  text "}"
  where 
    stripBytes [] = []
    stripBytes ((Byte _):xs) = stripBytes xs
    stripBytes (x:xs) = x:(stripBytes xs)
    makeArgs [] = empty
    makeArgs ((Fixed id _):[]) = text ("byte[] " ++ id)
    makeArgs ((LengthF id _):[]) = text ("byte[] " ++ id)
    makeArgs ((Unbounded id):[]) = text ("byte[] " ++ id)
    makeArgs ((Fixed id _):fields) = text ("byte[] " ++ id ++ ",")
    makeArgs ((LengthF id _):fields) = text ("byte[] " ++ id ++ ",")
    makeArgs ((Unbounded id):fields) = text ("byte[] " ++ ",")
    makeArgs _ = error "Unsupported type"
    makeIfs [] = empty
    makeIfs ((Fixed id _):fields) = text ("if (!(this." ++ id ++ ".setBytes(" ++ id ++ "))) {throw new InvalidInputException(\"" ++ id ++ "\");})") <$> makeIfs fields
    makeIfs ((LengthF id _):fields) = text ("if (!(this." ++ id ++ ".setBytes(" ++ id ++ "))) {throw new InvalidInputException(\"" ++ id ++ "\");})") <$> makeIfs fields
    makeIfs ((Unbounded id):fields) = text ("if (!(this." ++ id ++ ".setBytes(" ++ id ++ "))) {throw new InvalidInputException(\"" ++ id ++ "\");})") <$> makeIfs fields
    makeIfs _ = error "Unsupported type"

makeConstructor2 :: String -> FormatBody -> Doc
makeConstructor2 name body =
  nest level (
    text ("public " ++ capitalized name ++ "(byte[] format) throws InvalidInputException {") <$>
    
  )

--f x = 2 * f' x * y x
--  where f' a = 2 * a


{-
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

  where makeArgs [Field_XML id tag (Encoding enc)] 
          = "byte[] " ++ id 
        makeArgs (Field_XML id tag (Encoding enc) : xs) 
          = "byte[] " ++ id ++ "," ++ makeArgs xs
        makeArgs _ = ""
        makeAssigns [Field_XML id tag (Encoding enc)] 
          = text $ "this." ++ id ++ " = " ++ id ++ ";"
        makeAssigns (Field_XML id tag (Encoding enc) : xs) 
          = text ("this." ++ id ++ " = " ++ id ++ ";") 
          <$> makeAssigns xs
        makeAssigns _ = empty
        makeIfs [Field_XML id tag (Encoding enc)]
          = text $ "isValidInput(" ++ id ++ ") ){"
        makeIfs (Field_XML id tag (Encoding enc) :xs)
          = text ("isValidInput(" ++ id ++ ") && ") <+> makeIfs xs
        makeIfs _ = empty
        makeCases n [Field_XML id tag (Encoding enc)] 
          = text ("case " ++ (show n) ++ ": this." ++ id ++ " = b64decode(node.getTextContent().getBytes); break;")
        makeCases n (Field_XML id tag (Encoding enc) :xs)
          = text ("case " ++ (show n) ++ ": this." ++ id ++ " = b64decode(node.getTextContent().getBytes); break;")
            <$> makeCases (n+1) xs
        makeCases n _ = empty

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
  
  where makeFields [Field_XML id tag (Encoding enc)]
          = text $ "+ \"  " ++ "<" ++ tag ++ ">\" + new String(b64encode(" ++ id ++ ")) + \"</" ++ tag ++ ">\""
        makeFields (Field_XML id tag (Encoding enc) : xs)
          = text ("+ \"  " ++ "<" ++ tag ++ ">\" + new String(b64encode(" ++ id ++ ")) + \"</" ++ tag ++ ">\"")
            <$> makeFields xs
        makeFields _ = empty

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
makeGettersAndSetters [Field_XML id tag (Encoding enc)]
  = text ("public byte[] get" ++ id ++ "(){ return" ++ id ++ "; }")
  <$> text ("public void set" ++ id ++ "(byte[] " ++ id ++ "){ this."
    ++ id ++ " = isValidInput(" ++ id ++ ") ? " ++ id ++ " : " 
    ++ "this." ++ id ++ "; }")
makeGettersAndSetters (Field_XML id tag (Encoding enc) : xs)
  = text ("public byte[] get" ++ id ++ "(){ return" ++ id ++ "; }")
  <$> text ("public void set" ++ id ++ "(byte[] " ++ id ++ "){ this."
    ++ id ++ " = isValidInput(" ++ id ++ ") ? " ++ id ++ " : " 
    ++ "this." ++ id ++ "; }")
  <$> makeGettersAndSetters xs
makeGettersAndSetters _ = empty
-}
capitalized :: String -> String
capitalized (head:tail) = toUpper head : tail
capitalized [] = []

