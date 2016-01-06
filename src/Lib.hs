{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib
    ( mainEntry
    ) where

import System.Environment
import System.Exit
import Text.Hamlet
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html
import Database (load, addMetric, clearFile, generateJson, MetricHistory)
import Grep (identifierCount, findCount, findAllCount, saveCount)

renderTemplate :: String -> String -> String -> String
renderTemplate testVariable exit other = renderHtml ( $(shamletFile "mypage.hamlet") )

generateHtml = do
  exit <- generateJson "db.txt" "Identifier"
  writeFile "./report.html" $ renderTemplate "foobar" exit exit

saveGrep :: IO Int -> String -> IO MetricHistory
saveGrep results name =
  results >>= (addMetric "db.txt" name)

saveAllStats =
  saveGrep identifierCount "Identifier"
  `seq`
  saveGrep findCount "Find"
  `seq`
  saveGrep findAllCount "FindAll"
  `seq`
  saveGrep saveCount "Save"

mainEntry :: IO ()
mainEntry = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-a"] = saveAllStats >> exit
parse ["-s"] = generateHtml >> exit
parse ["-c"] = clearFile "db.txt" >> exit
parse ["-h"] = usage >> exit
parse ["-t"] = (identifierCount >>= (putStrLn . show)) >> exit
parse [] = usage >> exit

usage :: IO ()
usage = putStrLn "Usage: metrics \n [-h help]\n [-c clear database]\n [-s generate html file from database] \n [-a update database with todays metrics]\n"

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
