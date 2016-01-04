{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib
    ( mainEntry
    ) where

import System.Environment
import System.Exit
import System.Process (readProcess)
import Text.Hamlet
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html
import Data.List (isInfixOf)
import Database (load, addMetric, clearFile, generateJson)

renderTemplate :: String -> String -> String -> String
renderTemplate testVariable exit other = renderHtml ( $(shamletFile "mypage.hamlet") )

generateHtml = do
  exit <- generateJson "db.txt" "Identifier"
  writeFile "./report.html" $ renderTemplate "foobar" exit exit

grepRepo :: String -> IO Int
grepRepo search = do
  output <- readProcess "git" ["grep", "-w", search] "."
  (return . length . (filter (not . onlyCoreUsages)) . (filter (isInfixOf ".cs")) . lines) $ output

onlyCoreUsages :: String -> Bool
onlyCoreUsages a = (isInfixOf "Algo.Collateral.Core" a) 
  || (isInfixOf "Proxies" a)
  || (isInfixOf "Database" a)
  || (isInfixOf "Test" a)
  || (isInfixOf "Reporting" a)
  || (isInfixOf "Wilson" a)
  || (isInfixOf "packages" a)
  || (isInfixOf "lib" a)
  || (isInfixOf "Designer" a)

mainEntry :: IO ()
mainEntry = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-a"] = ((grepRepo "Identifier") >>= (addMetric "db.txt" "Identifier")) >> exit
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
