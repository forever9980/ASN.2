import java.nio.ByteBuffer;

/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
class ByteObj{
    private byte[] bytes;
    private byte[] length;

    protected ByteObj (byte[] l) {
        length = l;
    }
    protected ByteObj (byte b){
        setByte(b);
        setLength(new byte[] {1});
    }

    public byte[] getBytes(){ return bytes; }
    public byte[] getLength() { return length; }

    public void setByte(byte b) { setBytes(new byte[] {b});}
    public void setBytes(byte[] b){ bytes = b; }
    public void setLength(byte[] l) {
        length = l;
    }
}

public class Msg_ASN1 {
    private byte[] ALength = {0,0,7}; // Only set as fixed 7, due to testing.
    private ByteObj tag = new ByteObj((byte)0);
            
    private ByteObj NA = new ByteObj(new byte[3]);
    private ByteObj NB = new ByteObj(new byte[3]);
    private ByteObj A = new ByteObj(ALength);
    int numNodes = 4;
    /*******************************
     *                             *
     *         Constructors        *
     *                             *
     ******************************/
    public Msg_ASN1(byte tag,byte[] NA,byte[] NALength, byte[] NB, byte[] NBLength, byte[] A) throws InvalidInputException {
        if(isValidInput(this.NA,NA,NALength) && isValidInput(this.NB,NB,NBLength) && isValidInput(this.A,A,ALength)){
            // TODO: Should have a check to see if the length field has the proper value AND length
            // TODO: Should only take the x last bytes
            this.tag.setByte(tag);
            this.NA.setBytes(NA);
            this.NA.setLength(NALength);
            this.NB.setBytes(NB);
            this.NB.setLength(NBLength);
            this.A.setBytes(A);
        }else {
            throw new InvalidInputException();
        }
    }

    /**
     * Unsafe parser! No checks are implemented yet.
     */

    public Msg_ASN1(byte[] format) throws InvalidInputException {
        int pointer = 0;
        // Check the tag number is correct
        for(int i=1; i<=numNodes;i++){
            switch(i){
                // If the protocol specifies that there is no length field eg. fixed length
                // just put the corresponding data in.
                case 1: pointer = parse(format,pointer,tag,false); break;
                case 2: pointer = parse(format,pointer,NA,true);  break;
                case 3: pointer = parse(format,pointer,NB,true); break;
                case 4: pointer = parse(format,pointer,A,false); break;
            }
        }
    }


    private int parse(byte[] format, int pointer, ByteObj item,boolean hasLengthField) throws InvalidInputException {
        int p = pointer;
        if(hasLengthField){
            // First check the length of the length fields
            int lengthFieldLength = item.getLength().length;
            // and copy the corresponding length data.
            byte[] formatLength = new byte[lengthFieldLength];
            System.arraycopy(format,p,formatLength,0,lengthFieldLength);
            // Move the pointer the to behind the length field
            p += lengthFieldLength;
            // If the length field is already defined as something else than 0
            // check that the length field is correct
            if(getIntFromBytes(item.getLength()) != 0 &&
                    getIntFromBytes(item.getLength()) != getIntFromBytes(formatLength)){
                throw new InvalidInputException();
            }
            // Copy the length field into the item construct
            item.setLength(formatLength);
        }

        // Convert the length field data to a count
        int dataLength = getIntFromBytes(item.getLength());
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
                (1)
                + (NA.getLength().length + getIntFromBytes(NA.getLength()))
                + (NB.getLength().length + getIntFromBytes(NB.getLength()))
                + (getIntFromBytes(A.getLength()));
        byte[] bytes = new byte[length];
        int p = 0;
        // Important! Since "tag" and "A" doesn't have a length (it's fixed length of 1 byte)
        // should not include the length field
        System.arraycopy(tag.getBytes(),0,bytes,p,getIntFromBytes(tag.getLength())); p+= tag.getBytes().length;

        System.arraycopy(NA.getLength(),0,bytes,p,NA.getLength().length); p+=NA.getLength().length;
        System.arraycopy(NA.getBytes(),0,bytes,p,NA.getBytes().length); p += NA.getBytes().length;

        System.arraycopy(NB.getLength(),0,bytes,p,NB.getLength().length); p+=NB.getLength().length;
        System.arraycopy(NB.getBytes(),0,bytes,p,NB.getBytes().length); p += NB.getBytes().length;

        System.arraycopy(A.getBytes(),0,bytes,p,A.getBytes().length); p += A.getBytes().length; p+=A.getBytes().length;
        return bytes;
           }


    /*******************************
     *                             *
     *       Private methods       *
     *                             *
     ******************************/
    private boolean isValidInput(ByteObj item,byte[] bytes, byte[] length){
        int dataLength = bytes.length;
        int lengthData = getIntFromBytes(length);
        return (item.getLength().length == length.length && dataLength == lengthData);
    }

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

    public byte[] getNA(){ return NA.getBytes(); }
    public byte[] getNB(){ return NB.getBytes(); }
    public byte[] getA() { return A.getBytes();  }
}