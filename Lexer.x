{

{-

ASN.2 - Version 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

module Lexer (Token(..), 
              Ident, 
        AlexPosn(..), alexScanTokens, 
        token_posn) where

}

%wrapper "posn"

$char    = [0-9a-zA-Z_]

tokens :-
  $white+             ;
  "#".*               ;
  "XML"               { (\ p s -> TXML p) }
  "ASN1"              { (\ p s -> TASN1 p) }
  "byte"              { (\ p s -> TBYTE p) }
  $char+              { (\ p s -> TATOM p s) }
  "("                 { (\ p s -> TOPENP p)  }
  ")"                 { (\ p s -> TCLOSEP p) }
  "["                 { (\ p s -> TOPENSQ p) }
  "]"                 { (\ p s -> TCLOSESQ p) }
  ","                 { (\ p s -> TCOMMA p) }
  "="                 { (\ p s -> TEQ p) }
  "*"                 { (\ p s -> TSTAR p) }
{

data Token= 
   TATOM AlexPosn Ident 
   | TOPENP AlexPosn
   | TCLOSEP AlexPosn
   | TOPENSQ AlexPosn
   | TCLOSESQ AlexPosn
   | TCOMMA AlexPosn
   | TEQ AlexPosn
   | TXML AlexPosn
   | TASN1 AlexPosn
   | TCOLON AlexPosn
   | TBYTE AlexPosn
   | TSTAR AlexPosn
   deriving (Eq,Show)

token_posn (TATOM p _)=p
token_posn (TOPENP p)=p
token_posn (TCLOSEP p)=p
token_posn (TOPENSQ p)=p
token_posn (TCLOSESQ p)=p
token_posn (TCOMMA p)=p
token_posn (TEQ p)=p
token_posn (TXML p)=p
token_posn (TASN1 p)=p
token_posn (TCOLON p)=p
token_posn (TBYTE p)=p
token_posn (TSTAR p)=p

type Ident = String
}

