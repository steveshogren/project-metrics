{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib
    ( someFunc
    ) where

import System.Environment
import System.Exit
import System.Process (readProcess)
import Text.Hamlet
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html
import Database (load, addMetric, clearFile, generateJson)

renderTemplate :: String -> String -> String -> String
renderTemplate testVariable exit other = renderHtml ( $(shamletFile "mypage.hamlet") )

generateHtml = do
  exit <- generateJson "db.txt" "exit"
  writeFile "./report.html" $ renderTemplate "foobar" exit exit

grepRepo :: IO Int
grepRepo = do
  output <- readProcess "git" ["grep", "exit"] "."
  (return . length . lines) $ output

someFunc :: IO ()
someFunc = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-h"] = usage >> exit
parse ["-a"] = (grepRepo >>= (addMetric "db.txt" "exit")) >> exit
parse ["-s"] = generateHtml >> exit
parse ["-c"] = clearFile "db.txt" >> exit
parse [] = usage >> exit

usage :: IO ()
usage   = putStrLn ""

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
