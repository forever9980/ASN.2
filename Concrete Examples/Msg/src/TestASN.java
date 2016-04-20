/**
 * Created by buster on 3/13/16.
 */
class TestASN {
    private byte[] time;
    private byte[] random;
    private byte[] session_id;
    private byte[] cipher_suites;
    private byte[] comp_methods;
    private Client_Hello client_hello = null;

    TestASN() {
        time = new byte[] {1};
        random = new byte[] {2,2};
        session_id = new byte[] {3,3,3};
        cipher_suites = ("cipher_suites").getBytes();
        comp_methods = new byte[] {5,5,5,5};
    }

    void run() throws InvalidInputException{
        /**
        * Test that a message can be constructed, if formed correctly
        */
        try {
            client_hello = new Client_Hello(time,random,session_id,cipher_suites,comp_methods);
            PrintVariables("Test1",client_hello);
        } catch (InvalidInputException e) {
            e.printStackTrace();
            System.out.println("Test 1 failed");
        }

        /**
         * Try to get an encoded output
         */
        System.out.println("Test2");
        byte[] bytes = client_hello.encode();
        for(Byte b : bytes){
            System.out.print(b);
        }

        /**
         * Try to create an object from an encoded output
         */
        Client_Hello client_hello2 = new Client_Hello(bytes);
        PrintVariables("Test3", client_hello2);

        /**
         * Test corner cases
         */
    }

    private static void PrintVariables(String test, Client_Hello client_hello) {
        System.out.println();
        System.out.println(test);
        System.out.println("time = " + new String(client_hello.getTime()));
        System.out.println("random = " + new String(client_hello.getRandom()));
        System.out.println("session_id = " + new String(client_hello.getSession_id()));
        System.out.println("cipher_suites = " + new String(client_hello.getCipher_suites()));
        System.out.println("comp_methods = " + new String(client_hello.getComp_methods()));

        System.out.println();
    }
}
