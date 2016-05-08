{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

import Prelude hiding ((<$>))
import System.Directory
import Text.PrettyPrint.Leijen
import System.IO
import Data.List
import Lexer
import Parser
import Ast
import MakeDoc hiding(level)

level :: Int
level = 2

main :: IO ()
main = do
  createDirectoryIfMissing True "out"
  inp <- readFile "Concrete Examples/TLS.asn2"
  let tokens = alexScanTokens inp
  let formats = parser tokens
  if not (isDisjoint formats) then
    print "Formats are not disjoint. Leaving"
  else
    writeClasses formats

writeClasses :: [Format] -> IO ()
writeClasses [] = putStr "Done outputting classes."
writeClasses ((Format name ids body):xs) 
  = do writeDoc name ids body
       writeClasses xs

writeDoc :: String -> [Id] -> FormatBody -> IO ()
{- Perhaps should include checks for invalid tags in XML -}
writeDoc name ids body = do
  { handle <- openFile ("out/" ++ name ++ ".java") WriteMode
    ; hPutDoc handle (makeDoc name ids body)
    ; hClose handle
  }

makeDoc :: String -> [String] -> FormatBody -> Doc
makeDoc name ids body =
  makeImports body <$>
  nest level
  (makeHeader name <$>
    makePrivateVars body <$>
    makeConstructor name body
  )<$>
  text "}"