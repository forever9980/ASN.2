import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.StringReader;

/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * Example output using XML implementation
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
public class Msg_XML {
    String NA,NB,A;
    int numNodes = 3;
    /*******************************
     *                             *
     *         Constructors        *
     *                             *
     ******************************/
    public Msg_XML(String NA, String NB, String A) throws InvalidInputException {
        if (isValidInput(NA) && isValidInput(NB) && isValidInput(A) ){
            this.NA = NA;
            this.NB = NB;
            this.A = A;
        }else {
            throw new InvalidInputException();
        }
    }

    public Msg_XML(String format) throws Exception {
        Document document = loadXMLFromString(format);
        Node node = document.getDocumentElement().getFirstChild();      // Get the first child node
        for (int i = 1; i<=numNodes; i++){
            switch(i){
                case 1: this.NA = node.getTextContent(); break;
                case 2: this.NB = node.getTextContent(); break;
                case 3: this.A = node.getTextContent(); break;
            }
            node = node.getNextSibling().getNextSibling();              // Step untill next node
        }
    }

    /*******************************
     *                             *
     *       Public Methods        *
     *                             *
     ******************************/
    public boolean verify (){
        //Verify that this object does not contain illegal characters
        //And all needed fields are filled
        return (!(NA.isEmpty() && NB.isEmpty() && A.isEmpty())
                && (isValidInput(NA) && isValidInput(NB) && isValidInput(A)));
    }

    public String encode (){
        //Serialize / Pretty print the object
        return "<Msg_XML>\n"
                + "  " + "<NA>" + NA + "</NA>\n"
                + "  " + "<NB>" + NB + "</NB>\n"
                + "  " + "<A>"  + A  + "</A>\n"
                + "</Msg_XML>";
    }


    /*******************************
     *                             *
     *       Private methods       *
     *                             *
     ******************************/

    private boolean isValidInput(String chars){
        if (chars.isEmpty()) return false;
        for (int i = 0; i < chars.length()-1; i++){
            if (chars.charAt(i) == '<'){
                return false;
            }
        }
        return true;
    }

    private static Document loadXMLFromString(String xml) throws Exception
    {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        InputSource is = new InputSource(new StringReader(xml));
        return builder.parse(is);
    }

    /******************************
     *                             *
     *      Getters & Setters      *
     *                             *
     ******************************/

    public String getNA(){ return NA; }
    public String getNB(){ return NB; }
    public String getA() { return A;  }
    public void setNA(String NA){ this.NA = isValidInput(NA)? NA : this.NA;  }
    public void setNB(String NB){ this.NB = isValidInput(NB) ? NB : this.NB; }
    public void setA(String A)  { this.A  = isValidInput(A)  ? A : this.A; }
}