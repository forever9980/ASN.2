import java.nio.ByteBuffer;

/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
class ByteObj{
    private byte[] bytes;
    public ByteObj(byte[] b){ bytes=b; }
    public byte[] getBytes(){ return bytes; }
    public void setBytes(byte[] b){ bytes = b; }
}

public class Msg_ASN1 {
    ByteObj NA,NB,A;
    byte[] NALength={0x00,0x00,0x03},NBLength={0x00,0x00,0x03},ALength = {0x00,0x00,0x0F}; // Length fields are known from parsing
    byte tag;
    int numNodes = 3;
    /*******************************
     *                             *
     *         Constructors        *
     *                             *
     ******************************/
    public Msg_ASN1(byte tag,byte[] NA, byte[] NB, byte[] A) throws InvalidInputException {
        if(isValidInput(NA,1) && isValidInput(NB,2) && isValidInput(A,3)){
            this.tag = tag;
            this.NA = new ByteObj(NA);
            this.NB = new ByteObj(NB);
            this.A = new ByteObj(A);
        }else {
            throw new InvalidInputException();
        }
    }

    /**
     * Unsafe parser! No checks are implemented yet.
     */

    public Msg_ASN1(byte[] format) throws InvalidInputException {
        // For the TLS Handshake HANDSHAKE(tag, data) = tag · [data]3
        // Format would be [tag][length][length][length][data][data][data]...
        int pointer = 1;

        // Check the tag number is correct
        if (tag != format[0]) throw new InvalidInputException();

        for(int i=1; i<=numNodes;i++){
            switch(i){
                case 1: pointer = copyArray(format,pointer,NA,NALength); break;
                case 2: pointer = copyArray(format,pointer,NB,NBLength); break;
                case 3: pointer = copyArray(format,pointer,A,ALength); break;
            }
        }

    }

    private int copyArray(byte[] format, int pointer,ByteObj item,byte[] itemLength) throws InvalidInputException {
        byte[] length;
        //Check that the length bytes are correct
        length = new byte[item.getBytes().length];
        System.arraycopy(format,1,length,0,item.getBytes().length);
        if(length != itemLength) throw new InvalidInputException();
        // Copy the data
        System.arraycopy(format,length.length,item,0, ByteBuffer.wrap(length).getInt());
        pointer+=ByteBuffer.wrap(length).getInt();
        return pointer;
    }

    /*******************************
     *                             *
     *       Public Methods        *
     *                             *
     ******************************/
    public byte[] encode (){
        int length = (1) + (NALength.length+NA.getBytes().length) + (NBLength.length+NB.getBytes().length) + (ALength.length+A.getBytes().length);
        byte[] bytes = new byte[length];
        int pointer = 1;
        System.arraycopy(tag,0,bytes,0,1);
        System.arraycopy(NALength,0,bytes,pointer,NALength.length); pointer+=NALength.length;
        System.arraycopy(NA.getBytes(),0,bytes,pointer,NA.getBytes().length); pointer += NA.getBytes().length;
        System.arraycopy(NBLength,0,bytes,pointer,NBLength.length); pointer+=NBLength.length;
        System.arraycopy(NB.getBytes(),0,bytes,pointer,NB.getBytes().length); pointer += NB.getBytes().length;
        System.arraycopy(ALength,0,bytes,pointer,ALength.length); pointer+=ALength.length;
        System.arraycopy(A.getBytes(),0,bytes,pointer,A.getBytes().length); pointer += A.getBytes().length;
        return bytes;
           }


    /*******************************
     *                             *
     *       Private methods       *
     *                             *
     ******************************/

    private boolean isValidInput(byte[] bytes,int id){
        int length = bytes.length;
        switch(id){
            case 1: return isValidLength(NALength,length);
            case 2: return isValidLength(NBLength,length);
            case 3: return isValidLength(ALength,length);
        }
        return false;
    }

    /**
     * Tests whether the input has the length specified in the format.
     * @param itemLength
     * @param length
     * @return
     */
    private boolean isValidLength(byte[] itemLength,int length) {
        if(itemLength.length%2==0){
            return (length== ByteBuffer.wrap(itemLength).getInt());
        }else{
            byte[] b = new byte[itemLength.length+1];
            System.arraycopy(new byte[] {0x00},0,b,0,1);
            System.arraycopy(itemLength,0,b,1,itemLength.length);
            return (length==ByteBuffer.wrap(b).get());
        }
    }


    /******************************
     *                             *
     *      Getters & Setters      *
     *                             *
     ******************************/

    public byte[] getNA(){ return NA.getBytes(); }
    public byte[] getNB(){ return NB.getBytes(); }
    public byte[] getA() { return A.getBytes();  }
    public byte getTag() { return tag; }
    /*
    public void setNA(byte[] NA){ this.NA = isValidInput(NA,1)? NA : this.NA;  }
    public void setNB(byte[] NB){ this.NB = isValidInput(NB,2) ? NB : this.NB; }
    public void setA(byte[] A)  { this.A  = isValidInput(A,3)  ? A : this.A; }*/
}