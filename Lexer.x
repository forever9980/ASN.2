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

$char    = [0-9a-zA-Z]

tokens :-
  $white+             ;
  "#".*               ;
  $char+              { (\ p s -> TATOM p s) }
  "("                 { (\ p s -> TOPENP p)  }
  ")"                 { (\ p s -> TCLOSEP p) }
  "["                 { (\ p s -> TOPENSQ p) }
  "]"                 { (\ p s -> TCLOSESQ p) }
  ['"']               { (\ p s -> TQUOTE p) }
  ","                 { (\ p s -> TCOMMA p) }
  "="                 { (\ p s -> TEQ p) }
{

data Token= 
   TATOM AlexPosn Ident 
   | TOPENP AlexPosn
   | TCLOSEP AlexPosn
   | TOPENSQ AlexPosn
   | TCLOSESQ AlexPosn
   | TQUOTE AlexPosn
   | TCOMMA AlexPosn
   | TEQ AlexPosn
   deriving (Eq,Show)

token_posn (TATOM p _)=p
token_posn (TOPENP p)=p
token_posn (TCLOSEP p)=p
token_posn (TOPENSQ p)=p
token_posn (TCLOSESQ p)=p
token_posn (TQUOTE p)=p
token_posn (TCOMMA p)=p
token_posn (TEQ p)=p

type Ident = String
}

