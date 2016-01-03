{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
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
import Data.Time (formatTime, showGregorian, addDays, localDay, getCurrentTime, getCurrentTimeZone, utcToLocalTime)
import Data.Time.Format (defaultTimeLocale)
import Control.Monad(liftM2, liftM)

today :: IO String
today = do
  time <- liftM2 utcToLocalTime getCurrentTimeZone getCurrentTime
  return $ showGregorian $ localDay time

data CountDate = CountDate {
      date :: String
    , count  :: Int
    } deriving (Read, Show)

type MetricHistory = [CountDate]

load :: (Read a) => FilePath -> IO a
load f = do s <- readFile f
            return (read s)

save :: (Show a) => a -> FilePath -> IO ()
save x f = writeFile f (show x)

clearFile :: String -> IO ()
clearFile f = save ([]::MetricHistory) f

addMetric :: String -> Int -> IO MetricHistory
addMetric file count = do
  t <- today
  existing <- load file
  length existing `seq` (save (existing ++ [(CountDate{date=t,count=count})]) file
                         >> load file)

renderTemplate :: String -> String -> String -> String
renderTemplate testVariable exit other = renderHtml ( $(shamletFile "mypage.hamlet") )

generateHtml = writeFile "./report.html" $ renderTemplate "foobar" "[1, 2], [3, 4]"  "[1, 5], [2, 4]"

grepRepo :: IO Int
grepRepo = do
  output <- readProcess "git" ["grep", "exit"] "."
  (return . length . lines) $ output

someFunc :: IO ()
someFunc = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-h"] = usage >> exit
parse ["-a"] = (grepRepo >>= (addMetric "db.txt")) >> exit
parse ["-s"] = generateHtml >> exit
parse ["-c"] = clearFile "db.txt" >> exit
parse [] = usage >> exit

usage :: IO ()
usage   = putStrLn ""

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
