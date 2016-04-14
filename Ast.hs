{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

module Ast where
import Data.List

type Id = String

data Format = Format Id [Id] FormatBody
      deriving Show

data FormatBody = ASN1 [Field]
                | XML [Field]

data Field = Fixed Id Int
           | LengthF Id Int
           | Unbounded Id
           | Byte Char
           | Field

{-

Functions for checking disjointness of Formats

-}