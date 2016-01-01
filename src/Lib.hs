module Lib
    ( someFunc
    ) where

import System.Environment
import System.Exit
import System.Process (readProcess)

grepRepo ::  IO String
grepRepo = do
  readProcess "git" ["grep", "exit"] "."

someFunc :: IO ()
someFunc = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-h"] = usage  >> exit
parse ["-a"] = (grepRepo >>= putStrLn) >> exit
parse [] = usage >> exit

usage :: IO ()
usage   = putStrLn ""

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
