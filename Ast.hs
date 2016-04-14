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
      deriving Show

data Field = Fixed Id Int
           | LengthF Id Int
           | Unbounded Id
           | Byte Char
           | Field
      deriving Show

{-

Functions for checking disjointness of Formats

-}

{-
elem :: Byte -> Field -> Bool
elem c f = True

disjoint :: List -> List -> Bool
disjoint [] [] = False
disjoint [] (Byte c:F2) = True
disjoint [] (LengthF _ _:F2) = disjoint [] F2
disjoint [] (Fixed _ _:F2) = if (l>0) then True else disjoint [] F2
disjoint [] (Field _:F2 ) = disjoint [] F2
disjoint (f1:F1) (f2:F2) =
  case (f1,f2) of
    (Byte c,Byte c')        -> c != c' || disjoint F1 F2

    (Byte c,Fixed x l)      -> if l==0 then disjoint (c:F1) F2
                               else disjoint F1 (Fixed x (l-1)):F2

    (Byte c,LengthF f _)    -> disjoint (c:F1) F2
                            && disjoint F1 (f2:F2)

    (Byte c,Field f) not (elem c f) || disjoint F1 (f2:F2)

    (Fixed x l,Fixed y l')  -> if (l<=m) then disjoint F1 (Fixed y (l'-1)):F2
                               else disjoint (Fixed x (l-1)):F1 F2

    (Fixed x l,LengthF _ _) || (LengthF x l, Field _)
                            -> disjoint F1 (f2:F2)
                            && disjoint (Fixed x (l-1)):F1 F2

    (_,_)                   -> disjoint F1 (f2:F2) && disjoint (f1:F1) F2

    -}