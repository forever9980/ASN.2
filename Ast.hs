{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

module Ast where
import Data.List

type Id = String
type Tag = String

data Format = Format Id [Id] FormatBody
      deriving (Show)

data FormatBody = ASN1 [Field]
                | XML [Field]
      deriving (Show)

data Field = Fixed Id Int
           | LengthF Id Int
           | Unbounded Tag Id
           | Byte Int
           | Enc [Field]
      deriving (Show, Eq)

{-

Functions for checking disjointness of Formats

-}

getFields :: [Format] -> [Field]
getFields [] = []
getFields ((Format _ _ (ASN1 fields)):rest) = fields ++ (getFields rest)
getFields ((Format _ _ (XML fields)):rest) = fields ++ (getFields rest)

isDisjoint :: [Format] -> Bool
isDisjoint (format:[]) = True
isDisjoint (format:formats) =
  disjoint (getFields [format]) fields && (isDisjoint formats)
  where fields = getFields formats

disjoint :: [Field] -> [Field] -> Bool
disjoint [] [] = False
disjoint [] ((Byte c):f2) = True
disjoint ((Unbounded x idx):[]) ((Unbounded y idy):f2) = not (f2 == [])
disjoint [] ((Unbounded x idx):f2) = disjoint [] f2
disjoint [] ((LengthF _ _):f2) = disjoint [] f2
disjoint [] ((Fixed _ l):f2) = if (l>0) then True else disjoint [] f2
disjoint [] ((Enc _):f2) = disjoint [] f2
disjoint (f1:f1') (f2:f2') =
  case (f1,f2) of
    (Byte c,Byte c')            -> c /= c' || disjoint f1' f2'

    (c@(Byte _),Fixed x l)      -> if l==0 then disjoint (c:f1') f2'
                                   else disjoint f1' ((Fixed x (l-1)):f2')

    (c@(Byte _),LengthF f _)    -> disjoint (c:f1') f2'
                                && disjoint f1' (f2:f2')

    (c@(Byte _),Enc x)          -> not (elem c x) || disjoint f1' (f2:f2')

    (Fixed x l,Fixed y m)       -> if (l<=m) then disjoint f1' ((Fixed y (m-1)):f2')
                                   else disjoint ((Fixed x (l-1)):f1') f2'

    (Fixed x l,LengthF _ _)     -> disjoint f1' (f2:f2')
                                && disjoint ((Fixed x (l-1)):f1') f2'
                            
    (LengthF x l, Enc _)        -> disjoint f1' (f2:f2')
                                && disjoint ((Fixed x (l-1)):f1') f2'

    (Unbounded x idx, Unbounded y idy)  -> x /= y || disjoint f1' f2'

    (Unbounded x idx, Byte b)   -> True
    (Byte b, Unbounded x idx)   -> True

    otherwise                   -> disjoint f1' (f2:f2') && disjoint (f1:f1') f2'
disjoint f1 f2 = disjoint f2 f1