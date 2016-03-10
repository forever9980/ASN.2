{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

Notes:
data Concrete:
  Instead of using "Concrete = XML" this aproach is used
  Such that the tag XML in any given string does not
  give rise to a token. Should be changed when (if) states are supported in the Lexer

data Encoding:
  Should be changed to the following when (if) states are supported in the Lexer
  data Encoding = Base64
                | String
                deriving Show

Example:  [Format 
            "formatname"
              ["ID","ID","ID"]
              (Concrete 
                XML 
                [Field "ID" "Type" (Encoding Base64)])

-}

module Ast where
import Data.List

data Format = Format Id [Id] Concrete
      deriving Show

type Id = String
type Tag = String

data Concrete = Concrete String [Field]
        deriving Show

data Field = Field Id Tag Encoding
       deriving Show

newtype Encoding = Encoding String
         deriving Show

{-

Functions for checking disjointness of Formats

-}

getFormatName :: Format -> String
getFormatName (Format name _ _) = name

instance Eq Format where
  (Format nameA argsA formatA) == (Format nameB argsB formatB) 
    = nameA == nameB &&
      length argsA == length argsB &&
      formatA == formatB

instance Eq Concrete where
  (Concrete formatA argsA) == (Concrete formatB argsB)
    = formatA == formatB
    && length argsA == length argsB
    && sameArgTypes argsA argsB
    where
      compareTypes (Field _ _ (Encoding typeA)) (Field _ _ (Encoding typeB)) = typeA == typeB 
      sameArgTypes xs ys = 
        and (zipWith compareTypes xs ys)

disjoint :: (Eq a) => [a] -> Bool
disjoint [] = True
disjoint (x:xs) = and (map (\y -> x/=y) xs) && (disjoint xs)

hasValidTags :: [Field] -> Bool
hasValidTags [] = True
hasValidTags [(Field _ tag _)] =
 do
  let validInputs = ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9'] ++ ['-','_','.']
  let validStartChars = ['a'..'z'] ++ ['A'..'Z'] ++ ['_']
  (all (\e -> elem e validInputs) tag) && (elem (head tag) validStartChars)
hasValidTags (x:xs) = hasValidTags [x] && hasValidTags xs