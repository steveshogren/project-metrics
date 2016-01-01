module Lib
    ( someFunc
    ) where

import System.Environment
import System.Exit

someFunc :: IO ()
someFunc = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-h"] = (putStrLn "DLFJ")  >> exit
parse [] = usage >> exit

usage :: IO ()
usage   = putStrLn "Usage: dateParser \n [-v version]\n [-h help]\n [-c find oldest missing]\n [-b print bash gui] \n [-w write bash file] \n [-u update all git hooks] \n [-r find rebase commits in current]"

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
