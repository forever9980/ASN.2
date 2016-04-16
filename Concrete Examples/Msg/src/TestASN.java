/**
 * Created by buster on 3/13/16.
 */
public class TestASN {
    public TestASN() throws InvalidInputException {
        /**
         * Test that a message can be constructed, if formed correctly
         */
        Client_Hello msg_asn1 = null;
        byte tag = 1;
        byte[] NA  = "NAString".getBytes(), NB = "NBString".getBytes(), A = "AString".getBytes();
        byte[] NAL = {0,0,8};
        byte[] NBL = {0,0,8};

        try {
            msg_asn1 = new Client_Hello(tag,NA,NAL,NB,NBL,A);
            PrintVariables("Test1",msg_asn1);
        } catch (InvalidInputException e) {
            e.printStackTrace();
            System.out.println("Test 1 failed");
        }

        /**
         * Try to get an encoded output
         */
        System.out.println("Test2");
        byte[] bytes = msg_asn1.encode();
        for(int i = 0; i<bytes.length;i++){
            System.out.print(bytes[i]);
        }
        System.out.println();
        System.out.println(new String(bytes));


        /**
         * Try to create an object from an encoded output
         */
        System.out.println("Test 3");
        Client_Hello msg_xml3 = new Client_Hello(bytes);
        PrintVariables("Test4",msg_asn1);

        /**
         * Test corner cases
         */
    }

    private static void PrintVariables(String test, Client_Hello msg_asn) {
        System.out.println(test);
        System.out.println("NA = " + new String(msg_asn.getNA()));
        System.out.println("NB = " + new String(msg_asn.getNB()));
        System.out.println("A = " + new String(msg_asn.getA()));
        System.out.println();
    }
}
