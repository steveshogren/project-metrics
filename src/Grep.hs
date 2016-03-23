 module Grep
     ( grepRepo
       , countGrepRepo
       , identifierCount
       , saveCount
       , findCount
       , findAllCount
     ) where

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

countGrepRepo :: String -> String -> IO Int
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


identifierCount :: IO Int
identifierCount = (countGrepRepo "-w" "Identifier")
saveCount :: IO Int
saveCount = (countGrepRepo "" "\\.Save(")
findCount :: IO Int
findCount = (countGrepRepo "" "\\.Find(")
findAllCount :: IO Int
findAllCount = (countGrepRepo "" "\\.FindAll(")
