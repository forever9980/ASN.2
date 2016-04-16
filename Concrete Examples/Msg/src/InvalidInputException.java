/**
 * ASN.2 - A model approach to secure protocol implementation v. 2016
 * (C) Buster Kim Mejborn - 2016
 * All rights reserved
 */
public class InvalidInputException extends Throwable {
    //Parameterless Constructor
    public InvalidInputException() {}

    //Constructor that accepts a message
    public InvalidInputException(String message)
    {
        super(message);
    }
}
