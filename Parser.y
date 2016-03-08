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
%%
Formats : Formats_ {reverse $1}
Formats_ : Format {$1 :[]}
        | Formats_ Format {$2 : $1}

Format : ident '(' '"' ident '"' ',' '[' Ids ']' ')' '=' Concrete {Format $4 $8 $12}

Id : '"' ident '"' {$2}

Ids : Ids_ {reverse $1}
Ids_ : Id {$1 : []}
    | Ids_ ',' Id {$3 : $1}

Concrete : ident '(' '[' Fields ']' ')' {Concrete $1 $4}
         --| ASN1

Field : '(' '"' ident '"' ',' '"' ident '"' ',' '"' Encoding '"' ')' {Field $3 $7 $11}
Fields : Fields_ {reverse $1}
Fields_ : Field {$1 : []}
       | Fields_ ',' Field {$3 : $1}

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