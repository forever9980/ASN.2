/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
public class Program {
    public static void main(String args[]) throws Exception {
        String msg = "" +
                "<Msg_XML>"
                        + "<NA>" + "NAString" + "</NA>\n"
                        + "<NB>" + "NBString" + "</NB>\n"
                        + "<A>"  + "AString"  + "</A>\n"
                + "</Msg_XML>";
        Msg_XML msg_XML1 = new Msg_XML(msg);
        System.out.println(msg_XML1.getNA());
        System.out.println(msg_XML1.getNB());
        System.out.println(msg_XML1.getA());

        Msg_XML msg_XML2 = null;
        try {
            msg_XML2 = new Msg_XML("NAString2","NBString2","AString2");
        } catch (InvalidInputException e) {
            e.printStackTrace();
        }
        System.out.println(msg_XML2.getNA());
        System.out.println(msg_XML2.getNB());
        System.out.println(msg_XML2.getA());

        try {
            Msg_XML msg_XML3 = new Msg_XML("Test","sad","");
            System.out.println(msg_XML3.getNA());
            System.out.println(msg_XML3.getNB());
            System.out.println(msg_XML3.getA());
        } catch (InvalidInputException e) {
            System.out.println("Invalid input!");
        }
    }
}
