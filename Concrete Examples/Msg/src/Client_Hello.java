import java.nio.ByteBuffer;

/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */


class Client_Hello {
    private ByteObj time = new ByteObj(new byte[] {1});
    private ByteObj random = new ByteObj(new byte[] {2});
    private ByteObj session_id = new ByteObj(new byte[1]);
    private ByteObj cipher_suites = new ByteObj(new byte[2]);
    private ByteObj comp_methods = new ByteObj(new byte[1]);

    /*******************************
     *                             *
     *         Constructors        *
     *                             *
     ******************************/
    Client_Hello(byte[] time, byte[] random, byte[] session_id, byte[] cipher_suites, byte[] comp_methods) throws InvalidInputException {
        if (!(this.time.setBytes(time))) {throw new InvalidInputException("time");}
        if (!(this.random.setBytes(random))){throw new InvalidInputException("random");}
        if (!(this.session_id.setBytes(session_id))) {throw new InvalidInputException("session_id");}
        if (!(this.cipher_suites.setBytes(cipher_suites))) {throw new InvalidInputException("cipher_suites");}
        if (!(this.comp_methods.setBytes(comp_methods))) {throw new InvalidInputException("comp_methods");}
    }

    Client_Hello(byte[] format) throws InvalidInputException {
        int pointer = 0;
        if(format[pointer] == 1) {pointer+=1;} else failParse(1);
        if(format[pointer] == 3) {pointer+=1;} else failParse(1);
        if(format[pointer] == 3) {pointer+=1;} else failParse(1);
        pointer = parse(format,pointer,time,false);
        pointer = parse(format,pointer,random,false);
        pointer = parse(format,pointer,session_id,true);
        pointer = parse(format,pointer,cipher_suites,true);
        pointer = parse(format,pointer,comp_methods,true);
    }

    private void failParse(int id) throws InvalidInputException {
        System.out.println("Warning! Failed to parse at ID:" + id);
        throw new InvalidInputException();
        }


    private int parse(byte[] format, int pointer, ByteObj item,boolean hasVariableLengthField) throws InvalidInputException {
        // TODO: The parser should include checks for buffer overflows, even though it is not a problem in Java
        int p = pointer;
        if(hasVariableLengthField){
            // First check the length of the length fields
            int lengthFieldLength = item.getLengthField().length;
            // and copy the corresponding length data.
            byte[] formatLength = new byte[lengthFieldLength];
            System.arraycopy(format,p,formatLength,0,lengthFieldLength);
            // Move the pointer the to behind the length field
            p += lengthFieldLength;
            // If the length field is already defined as something else than 0
            // check that the length field is correct
            if(getIntFromBytes(item.getLengthField()) != 0 &&
                    getIntFromBytes(item.getLengthField()) != getIntFromBytes(formatLength)){
                throw new InvalidInputException();
            }
            // Copy the length field into the item construct
            item.setLength(formatLength);
        }

        // Convert the length field data to a count
        int dataLength = getIntFromBytes(item.getLengthField());
        // Copy the count of data
        byte[] data = new byte[dataLength];
        System.arraycopy(format,p,data,0,dataLength);
        // Move the pointer to after the data section
        p += dataLength;
        // Put the new data into the item
        item.setBytes(data);
        // Return the new pointer
        return p;
    }

    /*******************************
     *                             *
     *       Public Methods        *
     *                             *
     ******************************/
    public byte[] encode (){
        int length =
                + (1)
                + (1)
                + (1)
                + getIntFromBytes(time.getLengthField())
                + getIntFromBytes(random.getLengthField())
                + (session_id.getLengthField().length + getIntFromBytes(session_id.getLengthField()))
                + (cipher_suites.getLengthField().length + getIntFromBytes(cipher_suites.getLengthField()))
                + (comp_methods.getLengthField().length + getIntFromBytes(comp_methods.getLengthField()));

        byte[] bytes = new byte[length];
        int p = 0;
        System.arraycopy(new byte[] {1},0,bytes,p,1); p+=1;
        System.arraycopy(new byte[] {3},0,bytes,p,1); p+=1;
        System.arraycopy(new byte[] {3},0,bytes,p,1); p+=1;

        System.arraycopy(time.getBytes(),0,bytes,p,time.getBytes().length); p+= time.getBytes().length;
        System.arraycopy(random.getBytes(),0,bytes,p,random.getBytes().length); p+= random.getBytes().length;

        System.arraycopy(session_id.getLengthField(),0,bytes,p,session_id.getLengthField().length); p+=session_id.getLengthField().length;
        System.arraycopy(session_id.getBytes(),0,bytes,p,session_id.getBytes().length); p += session_id.getBytes().length;

        System.arraycopy(cipher_suites.getLengthField(),0,bytes,p,cipher_suites.getLengthField().length); p+= cipher_suites.getLengthField().length;
        System.arraycopy(cipher_suites.getBytes(),0,bytes,p,cipher_suites.getBytes().length); p += cipher_suites.getBytes().length;

        System.arraycopy(comp_methods.getLengthField(),0,bytes,p,comp_methods.getLengthField().length); p+=comp_methods.getLengthField().length;
        System.arraycopy(comp_methods.getBytes(),0,bytes,p,comp_methods.getBytes().length); p += comp_methods.getBytes().length;

        return bytes;
    }


    /*******************************
     *                             *
     *       Private methods       *
     *                             *
     ******************************/
    private int getIntFromBytes(byte[] item) {
        byte[] b = item;
        int p = 0;
        while (b.length % 4 != 0){
            b = new byte[b.length+1];
            p++;
            System.arraycopy(new byte[] {0x00},0,b,0,1);
            System.arraycopy(item,0,b,p,item.length);
        }
        return ByteBuffer.wrap(b).getInt();
    }


    /******************************
     *                             *
     *      Getters & Setters      *
     *                             *
     ******************************/

    byte[] getTime() {return time.getBytes();}
    byte[] getRandom() {return random.getBytes();}
    byte[] getSession_id() {return session_id.getBytes();}
    byte[] getCipher_suites() {return cipher_suites.getBytes();}
    byte[] getComp_methods() {return comp_methods.getBytes();}

    public void setTime(byte[] bytes) throws InvalidInputException {
        if (!time.setBytes(bytes)) {
            throw new InvalidInputException("time");
        }
    }
    public void setRandom(byte[] bytes) throws InvalidInputException {
        if (!random.setBytes(bytes)) {
            throw new InvalidInputException("random");
        }
    }

    public void setSession_id(byte[] bytes) throws InvalidInputException {
        if (!session_id.setBytes(bytes)) {
            throw new InvalidInputException("session_id");
        }
    }

    public void setCipher_suites(byte[] bytes) throws InvalidInputException {
        if (!cipher_suites.setBytes(bytes)) {
            throw new InvalidInputException("cipher_suites");
        }
    }

    public void setComp_methods(byte[] bytes) throws InvalidInputException {
        if (!comp_methods.setBytes(bytes)) {
            throw new InvalidInputException("comp_methods");
        }
    }

}

class ByteObj{
    private byte[] bytes;
    private byte[] length;

    ByteObj(byte[] l) {
        length = l;
    }

    byte[] getBytes(){ return bytes; }
    byte[] getLengthField() { return length; }
    private int getIntFromBytes(byte[] item) {
        byte[] b = item;
        int p = 0;
        while (b.length % 4 != 0){
            b = new byte[b.length+1];
            p++;
            System.arraycopy(new byte[] {0x00},0,b,0,1);
            System.arraycopy(item,0,b,p,item.length);
        }
        return ByteBuffer.wrap(b).getInt();
    }

    boolean setBytes(byte[] b){
        if(isValidInput(b)){
            bytes = b;
            setLength();
            return true;
        }
        return false;
    }

    void setLength(byte[] l) { length = l; }

    private boolean isValidInput(byte[] bytes){
        if (getLengthField() != null && getIntFromBytes(getLengthField()) > 0) {
            return (bytes.length == getIntFromBytes(getLengthField()));
        }
        return (bytes.length <= Math.pow(2,(8 * getLengthField().length)));
    }

    private void setLength() {
        int l = bytes.length;
        int numBytes = (l / 256) + 1;
        byte [] length1 = new byte[numBytes];
        for (int i = 0; i<numBytes; i++){
            length1[numBytes-1-i] = (byte) ((l >> i*8) & 0xFF);
        }
        System.arraycopy(length1,0,length,(length.length-length1.length),length1.length);
    }
}