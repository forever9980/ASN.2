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
  ','           { TCOMMA _}
  '='           { TEQ _}
  Byte          { TBYTE _}
  '*'           { TSTAR _}
  XML           { TXML _}
  ASN1          { TASN1 _}
%%

Formats  : Formats_ {reverse $1}
Formats_ : Format {$1 : []}
         | Formats_ Format {$2 : $1} {- {$1 ++ [$2]} -}
Format   : ident '(' ')' '=' FormatBody {Format $1 [] $5} 
         | ident '(' Ids ')' '=' FormatBody {Format $1 $3 $6}

Id   : ident {$1}
Ids  : Ids_ {reverse $1}
Ids_ : Id {$1 : []}
     | Ids_ ',' Id {$3 : $1}

FormatBody  : ASN1 '[' Fields_ASN ']' {ASN1 $3}
            | XML '[' Fields_XML ']' {XML $3}

Field_ASN   : Byte '(' ident ')' {Byte (read $3)}
            | ident '[' ident ']' {Fixed $1 (read $3)}
            | ident '[' '*' ident ']' {LengthF $1 (read $4)}
Fields_ASN  : Fields_ASN_ {reverse $1}
Fields_ASN_ : Field_ASN {$1 : []}
            | Fields_ASN_ ',' Field_ASN {$3 : $1}

Field_XML   : ident '(' ident ')' {Unbounded $1}
Fields_XML  : Fields_XML_ {reverse $1}
Fields_XML_ : Field_XML {$1 : []}
            | Fields_XML_ ',' Field_XML {$3 : $1}

{

happyError :: [Token] -> a
happyError tks = error ("Parse error at " ++ lcn ++ "\n" )
    where
    lcn = case tks of
          [] -> "end of file"
          tk:_ -> "line " ++ show l ++ ", column " ++ show c ++ " - Token: " ++ show tk
            where
            AlexPn _ l c = token_posn tk

}