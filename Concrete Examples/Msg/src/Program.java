import java.util.Base64;

/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
public class Program {
    public static void main(String args[]) throws Exception {
        /**
         * Test that a message can be constructed, if formed correctly
         */
        Msg_XML msg_XML2 = null;
        try {
            msg_XML2 = new Msg_XML("NAString".getBytes(),"NBString".getBytes(),"AString".getBytes());
        } catch (InvalidInputException e) {
            e.printStackTrace();
        }
        PrintVariables("Test1",msg_XML2);

        /**
         * Test that a message can be constructed by a correctly formed XML string
         */
        String msg = "" +
                "<Msg_XML>\n"
                        + "<nonce>" + new String(Base64.getEncoder().encode("NAString".getBytes())) + "</nonce>\n"
                        + "<nonce>" + new String(Base64.getEncoder().encode("NBString".getBytes())) + "</nonce>\n"
                        + "<agent>"  + new String(Base64.getEncoder().encode("AString".getBytes()))  + "</agent>\n"
                + "</Msg_XML>";
        Msg_XML msg_XML1 = new Msg_XML(msg.getBytes());
        PrintVariables("Test2",msg_XML1);


        /**
         * Try to get an encoded output
         */
        System.out.println("Test3");
        System.out.println(new String(msg_XML1.encode()));
        System.out.println();

        /**
         * Try to create an object from an encoded output
         */
        Msg_XML msg_xml3 = new Msg_XML(msg_XML1.encode());
        PrintVariables("Test4",msg_xml3);

        /**
         * Test what happens if a < or a > is put int the tags
         */
        try{
            String msg2 = "" +
                    "<Msg_XML>\n"
                    + "<NA>" + new String(Base64.getEncoder().encode("NAString".getBytes())) + "</NA>\n"
                    + "<NB>" + new String(Base64.getEncoder().encode("NBString".getBytes())) + "</NB>\n"
                    + "<A>"  + new String(Base64.getEncoder().encode("AString".getBytes()))  + "</A>\n"
                    + "</Msg_XML>";
            Msg_XML msg_XML4 = new Msg_XML(msg2.getBytes());
            System.out.println("Test5");
            System.out.println(new String(msg_XML4.encode()));
        }catch (Exception e){
            System.out.println("Test5 failed!");
        }

        try{
            String msg3 = "" +
                    "<Msg_XML>\n"
                    + "<N>A>" + new String(Base64.getEncoder().encode("NAString".getBytes())) + "</NA>\n"
                    + "<NB>" + new String(Base64.getEncoder().encode("NBString".getBytes())) + "</NB>\n"
                    + "<A>"  + new String(Base64.getEncoder().encode("AString".getBytes()))  + "</A>\n"
                    + "</Msg_XML>";
            Msg_XML msg_XML5 = new Msg_XML(msg3.getBytes());
            System.out.println("Test6");
            System.out.println(new String(msg_XML5.encode()));
        }catch (Exception e){
            System.out.println("Test6 failed!");
        }


    }

    private static void PrintVariables(String test,Msg_XML msg_XML2) {
        System.out.println(test);
        System.out.println("NA = " + new String(msg_XML2.getNA()));
        System.out.println("NB = " + new String(msg_XML2.getNB()));
        System.out.println("A = " + new String(msg_XML2.getA()));
        System.out.println();
    }
}
