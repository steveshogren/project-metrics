module Database (
                load
                , addMetric
                , clearFile
                , generateJson
                , Metric
                , MetricHistory) where

import Data.Time ( showGregorian,  localDay, getCurrentTime, getCurrentTimeZone, utcToLocalTime)
import Data.Time.Format (defaultTimeLocale)
import Control.Monad(liftM2, liftM)
import qualified Data.Map as M
import qualified Data.List as L

today :: IO String
today = do
  time <- liftM2 utcToLocalTime getCurrentTimeZone getCurrentTime
  return $ showGregorian $ localDay time

type Metric = M.Map String Int
type MetricHistory = M.Map String Metric

load :: (Read a) => FilePath -> IO a
load f = do s <- readFile f
            return (read s)

save :: (Show a) => a -> FilePath -> IO ()
save x f = writeFile f (show x)

clearFile :: String -> IO ()
clearFile f = save (M.empty::MetricHistory) f

loadMetric :: MetricHistory -> String -> Metric
loadMetric db metricName = do
  case M.lookup metricName db of
    Nothing -> M.empty
    Just metric -> metric

addMetric :: String -> String -> Int -> IO MetricHistory
addMetric file metricName count = do
  t <- today
  db <- load file
  let innerMetric = loadMetric db metricName
      updatedMap = (M.insert metricName (M.insert t count innerMetric) db)
    in length updatedMap `seq` (save updatedMap file >> load file)

makeJson :: Metric -> String
makeJson = L.intercalate "," . map (\(date, cnt) -> "['" ++ date ++ "', " ++ (show cnt) ++ "]") . M.toAscList
-- makeJson = L.intercalate "," . map (\(date, cnt) -> "[\"" ++ date ++ "\", " ++ (show cnt) ++ "]") . M.toAscList

generateJson file metricName = do
  db <- load file
  return $ makeJson $ loadMetric db metricName




