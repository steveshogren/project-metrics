 module Grep
     ( grepRepo
       , countGrepRepo
       , identifierCount
       , saveCount
       , findCount
       , findAllCount
     ) where

import Data.Functor ((<$>))
import Data.Text (toLower, pack, isInfixOf, isPrefixOf)
import System.Process (readProcess)

contains :: String -> String -> Bool
contains a b =
  isInfixOf (toLower . pack $ a) (toLower . pack $ b)
   || isPrefixOf (toLower . pack $ a) (toLower . pack $ b)

filterOnlyValid :: String -> [String]
filterOnlyValid = ((filter (not . ormOrFringeUsages)) . (filter (contains ".cs")) . lines)

grepRepo :: String -> String -> IO [String]
grepRepo prefix search =
  if prefix == "" then filterOnlyValid <$> readProcess "git" ["grep", search] "."
  else filterOnlyValid <$> readProcess "git" ["grep", prefix, search] "."

countGrepRepo prefix search = length <$> grepRepo prefix search

ormOrFringeUsages :: String -> Bool
ormOrFringeUsages a = (contains "Algo.Collateral.Core" a)
  || (contains "Proxies" a)
  || (contains "statistics" a)
  || (contains "Database" a)
  || (contains "Test" a)
  || (contains "Reporting" a)
  || (contains "Wilson" a)
  || (contains "packages" a)
  || (contains "lib" a)
  || (contains "codesmith" a)
  || (contains "datalayer" a)
  || (contains "Designer" a)


identifierCount = (countGrepRepo "-w" "Identifier")
saveCount = (countGrepRepo "" "\\.Save(")
findCount = (countGrepRepo "" "\\.Find(")
findAllCount = (countGrepRepo "" "\\.FindAll(")
