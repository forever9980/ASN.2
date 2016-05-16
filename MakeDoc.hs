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

makeConstructor :: String -> FormatBody -> Doc
makeConstructor name (ASN1 fields) = 
  makeASNConstructor1 name (ASN1 fields) <$> 
  makeASNConstructor2 name (ASN1 fields) <$>
  makeFailParse <$>
  makeParse
makeConstructor name (XML fields) = makeXMLConstructor name fields
 
makeXMLConstructor :: String -> [Field] -> Doc
makeXMLConstructor name fields =
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

  where makeArgs [Unbounded tag id] 
          = "byte[] " ++ id 
        makeArgs (Unbounded tag id : xs) 
          = "byte[] " ++ id ++ "," ++ makeArgs xs
        makeArgs _ = ""
        makeAssigns [Unbounded tag id] 
          = text $ "this." ++ id ++ " = " ++ id ++ ";"
        makeAssigns (Unbounded tag id : xs) 
          = text ("this." ++ id ++ " = " ++ id ++ ";") 
          <$> makeAssigns xs
        makeAssigns _ = empty
        makeIfs [Unbounded tag id]
          = text $ "isValidInput(" ++ id ++ ") ){"
        makeIfs (Unbounded tag id : xs)
          = text ("isValidInput(" ++ id ++ ") && ") <+> makeIfs xs
        makeIfs _ = empty
        makeCases n [Unbounded tag id] 
          = text ("case " ++ (show n) ++ ": this." ++ id ++ " = b64decode(node.getTextContent().getBytes); break;")
        makeCases n (Unbounded tag id : xs)
          = text ("case " ++ (show n) ++ ": this." ++ id ++ " = b64decode(node.getTextContent().getBytes); break;")
            <$> makeCases (n+1) xs
        makeCases n _ = empty

makeASNConstructor1 :: String -> FormatBody -> Doc
makeASNConstructor1 name (ASN1 fields) =
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
    makeArgs ((Unbounded tag id):[]) = text ("byte[] " ++ id)
    makeArgs ((Fixed id _):fields) = text ("byte[] " ++ id ++ ",")
    makeArgs ((LengthF id _):fields) = text ("byte[] " ++ id ++ ",")
    makeArgs _ = error "Unsupported type"
    makeIfs [] = empty
    makeIfs ((Fixed id _):fields) = text ("if (!(this." ++ id ++ ".setBytes(" ++ id ++ "))) {throw new InvalidInputException(\"" ++ id ++ "\");})") <$> makeIfs fields
    makeIfs ((LengthF id _):fields) = text ("if (!(this." ++ id ++ ".setBytes(" ++ id ++ "))) {throw new InvalidInputException(\"" ++ id ++ "\");})") <$> makeIfs fields
    makeIfs _ = error "Unsupported type"

makeASNConstructor2 :: String -> FormatBody -> Doc
makeASNConstructor2 name (ASN1 fields) =
  nest level (
    text ("public " ++ capitalized name ++ "(byte[] format) throws InvalidInputException {") <$>
    text ("int pointer = 0;") <$>
    makeArgs fields
  ) <$>
  text "}"
  where
    makeArgs [] = empty
    makeArgs ((Byte b):xs) = text ("if(format[pointer] == " ++ show b ++ ") {pointer+=1;} else failParse(1);") <$> makeArgs xs
    makeArgs ((Fixed id _):xs) = text ("pointer = parse(format,pointer," ++ id ++ ",false);") <$> makeArgs xs
    makeArgs ((LengthF id _):xs) = text ("pointer = parse(format,pointer," ++ id ++ ",true);") <$> makeArgs xs
    makeArgs ((Unbounded tag id):xs) = text ("pointer = parse(format,pointer," ++ id ++ ",false);") <$> makeArgs xs
    makeArgs _ = error "Unsupported type"

makeFailParse :: Doc
makeFailParse = nest level (
  text ("private void failParse (int id) throws InvalidInputException {") <$>
    text "System.out.println(\"Warning! Failed to parse at ID:\" + id);" <$>
    text "throw new InvalidInputException();"
    ) <$> text "}"

makeParse :: Doc
makeParse = nest level (
  text "private int parse(byte[] format, int pointer, ByteObj item,boolean hasVariableLengthField) throws InvalidInputException {" <$>
    text "int p = pointer;" <$>
    nest level (
      text "if(hasVariableLengthField){" <$>
        text "int lengthFieldLength = item.getLengthField().length;" <$>
        text "byte[] formatLength = new byte[lengthFieldLength];" <$>
        text "System.arraycopy(format,p,formatLength,0,lengthFieldLength);" <$>
        text "p += lengthFieldLength;" <$>
        nest level(
          text "if(getIntFromBytes(item.getLengthField()) != 0 &&" <$>
            text "getIntFromBytes(item.getLengthField()) != getIntFromBytes(formatLength)){" <$>
            text "throw new InvalidInputException();"
          ) <$>
        text "}" <$>
        text "item.setLength(formatLength);"
      )
    <$>
    text "}" <$>
    text "int dataLength = getIntFromBytes(item.getLengthField());" <$>
    text "byte[] data = new byte[dataLength];" <$>
    text "System.arraycopy(format,p,data,0,dataLength);" <$>
    text "p += dataLength;" <$>
    text "item.setBytes(data);" <$>
    text "return p;"
  ) <$>
  text "}"

makeEncode :: String -> FormatBody -> Doc
makeEncode name (ASN1 fields) = makeASNEncode fields
makeEncode name (XML fields) = makeXMLEncode name fields

makeASNEncode :: [Field] -> Doc
makeASNEncode fields =
  nest level (
    text "public byte[] encode () {" <$>
      nest level (
      text "int length = " <$>
        (makeArgs1 fields)
      ) <$>
      text "byte[] bytes = new byte[length];" <$>
      text "int p = 0;" <$>
      (makeArgs2 fields) <$>
      text "return bytes;"
    ) <$>
  text "}"
  where makeArgs1 [] = text ";"
        makeArgs1 ((Byte _):xs) = text "+ (1)" <$> makeArgs1 xs
        makeArgs1 ((Fixed id _):xs) = text ("+ getIntFromBytes(" ++ id ++ ".getLengthField())") <$> makeArgs1 xs
        makeArgs1 ((LengthF id _):xs) =  text ("+ (" ++ id ++ ".getLengthField().length + getIntFromBytes(" ++ id ++ ".getLengthField()))") <$> makeArgs1 xs
        makeArgs1 _ = error "Unsupported"
        makeArgs2 [] = empty
        makeArgs2 ((Byte b):xs) = text ("System.arraycopy(new byte[] {" ++ (show b) ++ ",0,bytes,p,1); p+=1;") <$> makeArgs2 xs
        makeArgs2 ((Fixed id _):xs) = text ("System.arraycopy(" ++ id ++ ".getBytes(),0,bytes,p," ++ id ++ ".getBytes().length); p+= " ++ id ++ ".getBytes().length;") <$> makeArgs2 xs
        makeArgs2 ((LengthF id _):xs) =
          text ("System.arraycopy(" ++ id ++ ".getLengthField(),0,bytes,p," ++ id ++ ".getLengthField().length); p+=" ++ id ++ ".getLengthField().length;") <$>
          text ("System.arraycopy(" ++ id ++ ".getBytes(),0,bytes,p," ++ id ++ ".getBytes().length); p += " ++ id ++ ".getBytes().length;") <$> makeArgs2 xs

makeXMLEncode :: String -> [Field] -> Doc
makeXMLEncode name fields =
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
  
  where makeFields [Unbounded tag id]
          = text $ "+ \"  " ++ "<" ++ tag ++ ">\" + new String(b64encode(" ++ id ++ ")) + \"</" ++ tag ++ ">\""
        makeFields (Unbounded tag id : xs)
          = text ("+ \"  " ++ "<" ++ tag ++ ">\" + new String(b64encode(" ++ id ++ ")) + \"</" ++ tag ++ ">\"")
            <$> makeFields xs
        makeFields _ = empty

makeStatics :: String -> FormatBody -> Doc
makeStatics name (XML fields) = makeXMLPrivateMethods <$> makeXMLGettersAndSetters fields
makeStatics name (ASN1 fields) = makeASNStatics <$> makeASNGettersAndSetters fields


makeASNStatics :: Doc
makeASNStatics = 
  nest level(
    text "private int getIntFromBytes(Byte[] item) {" <$>
    text "byte[] b = item;" <$>
    text "int p = 0;" <$>
    nest level(
        text "while (b.length % 4 != 0){" <$>
        text "b = new byte[b.length+1];" <$>
        text "p++;" <$>
        text "System.arraycopy(new byte[] {0x00},0,b,0,1);" <$>
        text "System.arraycopy(item,0,b,p,item.length);" 
      ) <$>
    text "}" <$>
    text "return ByteBuffer.wrap(b).getInt()"
  ) <$>
  text "}"

makeASNGettersAndSetters :: [Field] -> Doc
makeASNGettersAndSetters [] = empty
makeASNGettersAndSetters ((Fixed id _):xs) =
  text ("byte[] get" ++ capitalized id ++ "() {return " ++ id ++ ".getBytes();}") <$>
  nest level (
    text ("public void set" ++ capitalized id ++ "(byte[] bytes) throws InvalidInputException {") <$>
    nest level (
      text ("if (!" ++ id ++ ".setBytes(bytes)) {") <$>
        text ("throw new InvalidInputException" ++ id ++ ");")
      )
    )
makeASNGettersAndSetters ((LengthF id _):xs) =
  text ("byte[] get" ++ capitalized id ++ "() {return " ++ id ++ ".getBytes();}") <$>
  nest level (
    text ("public void set" ++ capitalized id ++ "(byte[] bytes) throws InvalidInputException {") <$>
    nest level (
      text ("if (!" ++ id ++ ".setBytes(bytes)) {") <$>
        text ("throw new InvalidInputException" ++ id ++ ");")
      )
    )
makeASNGettersAndSetters _ = empty

makeASNByteObjClass :: Doc
makeASNByteObjClass =
  nest level (
      text "class ByteObj{" <$>
      text "private byte[] bytes;" <$>
      text "private byte[] length;" <$>
      nest level (
        text "ByteObj(byte[] l) {" <$>
          text "length = l;"
        ) <$>
      text "}" <$>
      text "byte[] getBytes() { return bytes; }" <$>
      text "getLengthField() { return length; }" <$>
      nest level (
        text "private int getIntFromBytes(byte[] item) {" <$>
          text "byte[] b = item;" <$>
          text "int p = 0;" <$>
          nest level (
            text "while (b.length %4 != 0) {" <$>
              text "b = new byte[b.length+1];" <$>
              text "p++;" <$>
              text "System.arraycopy(new byte[] {0x00},0,b,0,1);" <$>
              text "System.arraycopy(item,0,b,p,item.length);"
            ) <$>
          text "}" <$>
          text "return ByteBuffer.wrap(b).getInt();"
        ) <$>
      text "}" <$>
      nest level (
        text "boolean setBytes(byte[] b){" <$>
          nest level (
            text "if(isValidInput(b)){" <$>
              text "bytes = b;" <$>
              text "setLength();" <$>
              text "return true;"
            ) <$>
          text "}" <$>
          text "return false;"
        ) <$>
      text "}" <$>
      text "void setLength(byte[] l) {length = l;}" <$>
      nest level (
        text "private boolean isValidInput(byte[] bytes){" <$>
          nest level (
            text "if(getLengthField() != null && getIntFromBytes(getLengthField()) > 0) {" <$>
              text "return (bytes.length == getIntFromBytes(getLengthField()));" 
            ) <$>
          text "}" <$>
          text "return (bytes.length <= Math.pow(2,(8 * getLengthField().length)));"
        ) <$>
      text "}" <$>
      nest level (
        text "private void setLength() {" <$>
          text "int l = bytes.length;" <$>
          text "int numBytes = (l / 256) + 1;" <$>
          text "byte [] length1 = new byte[numBytes];" <$>
          nest level(
            text "for (int i = 0; i<numBytes; i++){" <$>
              text "length1[numBytes-1-i] = (byte) ((l >> i*8) & 0xFF);"
            ) <$>
          text "}" <$>
          text "System.arraycopy(length1,0,length,(length.length-length1.length),length1.length);"
        )<$>
      text "}"
    ) <$>
  text "}"

makeXMLPrivateMethods :: Doc
makeXMLPrivateMethods =
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

makeXMLGettersAndSetters :: [Field] -> Doc
makeXMLGettersAndSetters [Unbounded tag id]
  = text ("public byte[] get" ++ id ++ "(){ return" ++ id ++ "; }")
  <$> text ("public void set" ++ id ++ "(byte[] " ++ id ++ "){ this."
    ++ id ++ " = isValidInput(" ++ id ++ ") ? " ++ id ++ " : " 
    ++ "this." ++ id ++ "; }")
makeXMLGettersAndSetters (Unbounded tag id : xs)
  = text ("public byte[] get" ++ id ++ "(){ return" ++ id ++ "; }")
  <$> text ("public void set" ++ id ++ "(byte[] " ++ id ++ "){ this."
    ++ id ++ " = isValidInput(" ++ id ++ ") ? " ++ id ++ " : " 
    ++ "this." ++ id ++ "; }")
  <$> makeXMLGettersAndSetters xs
makeXMLGettersAndSetters _ = empty



capitalized :: String -> String
capitalized (head:tail) = toUpper head : tail
capitalized [] = []