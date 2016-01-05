{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib
    ( mainEntry
      , grepRepo
      , countGrepRepo
    ) where

import System.Environment
import System.Exit
import System.Process (readProcess)
import Text.Hamlet
import Data.Text (toLower, pack, isInfixOf, isPrefixOf)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html
import Database (load, addMetric, clearFile, generateJson)
import Data.Functor ((<$>))

renderTemplate :: String -> String -> String -> String
renderTemplate testVariable exit other = renderHtml ( $(shamletFile "mypage.hamlet") )

generateHtml = do
  exit <- generateJson "db.txt" "Identifier"
  writeFile "./report.html" $ renderTemplate "foobar" exit exit

contains :: String -> String -> Bool
contains a b =
  isInfixOf (toLower . pack $ a) (toLower . pack $ b)
   || isPrefixOf (toLower . pack $ a) (toLower . pack $ b)

grepRepo :: String -> IO [String]
grepRepo search = do
  output <- readProcess "git" ["grep", "-w", search] "."
  (return . (filter (not . onlyCoreUsages)) . (filter (contains ".cs")) . lines) $ output

countGrepRepo a = length <$> grepRepo a

onlyCoreUsages :: String -> Bool
onlyCoreUsages a = (contains "Algo.Collateral.Core" a)
  || (contains "Proxies" a)
  || (contains "statistics" a)
  || (contains "Database" a)
  || (contains "Test" a)
  || (contains "Reporting" a)
  || (contains "Wilson" a)
  || (contains "packages" a)
  || (contains "lib" a)
  || (contains "Designer" a)

mainEntry :: IO ()
mainEntry = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-a"] = ((countGrepRepo "Identifier") >>= (addMetric "db.txt" "Identifier")) >> exit
parse ["-s"] = generateHtml >> exit
parse ["-c"] = clearFile "db.txt" >> exit
parse ["-h"] = usage >> exit
-- parse ["-t"] = ((testGrep "Identifier") >>= putStrLn) >> exit
parse [] = usage >> exit

usage :: IO ()
usage = putStrLn "Usage: metrics \n [-h help]\n [-c clear database]\n [-s generate html file from database] \n [-a update database with todays metrics]\n"

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
