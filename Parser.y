{
{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

module Parser where
import Lexer
import Ast
}

%name parser
%tokentype {Token}

%token      
  ident         { TATOM _ $$}
  '('           { TOPENP _  }
  ')'           { TCLOSEP _ }
  '['           { TOPENSQ _ }
  ']'           { TCLOSESQ _}
  '"'           { TQUOTE _}
  ','           { TCOMMA _}
  '='           { TEQ _}
  XML           { TXML _}
  ASN           { TASN _}
%%
Formats  : Formats_ {reverse $1}
Formats_ : Format {$1 : []}
         | Formats_ Format {$2 : $1}

Format : ident '(' '"' ident '"' ',' '[' Ids ']' ')' '=' Concrete {Format $4 $8 $12}

Id : '"' ident '"' {$2}

Ids  : Ids_ {reverse $1}
Ids_ : Id {$1 : []}
     | Ids_ ',' Id {$3 : $1}

Concrete : XML '(' '[' Fields_XML ']' ')' {XML "XML" $4}
         | ASN '(' '[' Fields_ASN ']' ')' {ASN "ASN1" $4}

Field_ASN   : '(' '"' ident '"' ',' '"' ident '"' ')' {Field_ASN $3 $7}
Fields_ASN  : Fields_ASN_ {reverse $1}
Fields_ASN_ : Field_ASN {$1 : []}
            | Fields_ASN_ ',' Field_ASN {$3 : $1}


Field_XML   : '(' '"' ident '"' ',' '"' ident '"' ',' '"' Encoding '"' ')' {Field_XML $3 $7 $11}
Fields_XML  : Fields_XML_ {reverse $1}
Fields_XML_ : Field_XML {$1 : []}
            | Fields_XML_ ',' Field_XML {$3 : $1}

Encoding : ident {Encoding $1}

{

happyError :: [Token] -> a
happyError tks = error ("Parse error at " ++ lcn ++ "\n" )
    where
    lcn =   case tks of
          [] -> "end of file"
          tk:_ -> "line " ++ show l ++ ", column " ++ show c ++ " - Token: " ++ show tk
            where
            AlexPn _ l c = token_posn tk

}