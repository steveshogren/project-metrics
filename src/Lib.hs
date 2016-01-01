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

renderTemplate :: String -> String -> String -> String
renderTemplate testVariable exit other = renderHtml ( $(shamletFile "mypage.hamlet") )

s = writeFile "./report.html" $ renderTemplate "foobar" "[1, 2], [3, 4]"  "[1, 5], [2, 4]"

m :: IO ()
m = putStrLn $ renderHtml [shamlet|
<p>Hello, my name is #{show 3} and I am #{show 4}.
<p>
    Let's do some funny stuff with my name: #
    <b>#{show 4}
<p>Oh, and in 5 years I'll be #{show 3} years old.
|]

grepRepo ::  IO String
grepRepo = do
  output <- readProcess "git" ["grep", "exit"] "."
  (return . show . length . lines) $ output

someFunc :: IO ()
someFunc = getArgs >>= parse

parse :: [String] -> IO ()
parse ["-h"] = usage  >> exit
parse ["-a"] = (grepRepo >>= putStrLn) >> exit
parse ["-s"] = s >> exit
parse ["-m"] = m >> exit
parse [] = usage >> exit

usage :: IO ()
usage   = putStrLn ""

exit :: IO a
exit = exitSuccess

die :: IO a
die = exitWith (ExitFailure 1)
