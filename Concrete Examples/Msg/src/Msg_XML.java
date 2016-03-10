import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.ByteArrayInputStream;
import java.io.StringReader;
import java.util.Base64;

/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * Example on how output should look using XML implementation
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
public class Msg_XML {
    private byte[] NA;
    private byte[] NB;
    private byte[] A;
    private int numNodes = 3;
    /*******************************
     *                             *
     *         Constructors        *
     *                             *
     ******************************/
    public Msg_XML(byte[] NA, byte[] NB, byte[] A) throws InvalidInputException {
        if (isValidInput(NA) && isValidInput(NB) && isValidInput(A) ){
            this.NA = NA;
            this.NB = NB;
            this.A = A;
        }else {
            throw new InvalidInputException();
        }
    }

    public Msg_XML(byte[] format) throws Exception {
    Document document = loadXML(format);
        Node node = document.getDocumentElement().getFirstChild();
        // Check if there's a text element in the XML root and skip it.
        if(node.getNodeType()==3) { node = node.getNextSibling(); }

        for (int i = 1; i<=numNodes; i++){
            switch(i){
                case 1: this.NA = b64decode(node.getTextContent().getBytes()); break;
                case 2: this.NB = b64decode(node.getTextContent().getBytes()); break;
                case 3: this.A = b64decode(node.getTextContent().getBytes()); break;
            }
            node = node.getNextSibling().getNextSibling();              // Step until next node
        }
    }

    /*******************************
     *                             *
     *       Public Methods        *
     *                             *
     ******************************/
    public byte[] encode (){
        //Serialize / Pretty print the object
        return ("<Msg_XML>\n"
                + "  " + "<nonce>" + new String(b64encode(NA)) + "</nonce>\n"
                + "  " + "<nonce>" + new String(b64encode(NB)) + "</nonce>\n"
                + "  " + "<agent>"  + new String(b64encode(A))  + "</agent>\n"
                + "</Msg_XML>").getBytes();
    }

    /*******************************
     *                             *
     *       Private methods       *
     *                             *
     ******************************/

    private byte[] b64encode(byte[] b){
        return Base64.getEncoder().encode(b);
    }

    private byte[] b64decode(byte[] b){
        return Base64.getDecoder().decode(b);
    }

    private boolean isValidInput(byte[] chars){
        for(byte b : chars){
            if (b == 60) return false;
        }
        return true;
    }

    private static Document loadXML(byte[] xml) throws Exception
    {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(new ByteArrayInputStream(xml));
    }

    /******************************
     *                             *
     *      Getters & Setters      *
     *                             *
     ******************************/

    public byte[] getNA(){ return NA; }
    public byte[] getNB(){ return NB; }
    public byte[] getA() { return A;  }
    public void setNA(byte[] NA){ this.NA = isValidInput(NA)? NA : this.NA;  }
    public void setNB(byte[] NB){ this.NB = isValidInput(NB) ? NB : this.NB; }
    public void setA(byte[] A)  { this.A  = isValidInput(A)  ? A : this.A; }
}