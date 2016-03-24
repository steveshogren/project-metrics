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
import Control.Monad.Trans (liftIO, MonadIO)
import Control.Monad.Reader (ReaderT, ask, runReaderT)

today :: IO String
today = do
  time <- liftM2 utcToLocalTime getCurrentTimeZone getCurrentTime
  return $ showGregorian $ localDay time

type Metric = M.Map String Int
type MetricHistory = M.Map String Metric

load :: (Read a) => ReaderT FilePath IO a
load = do
  f <- ask
  liftIO $ (read <$> readFile f)

save :: (Show a) => a -> ReaderT FilePath IO ()
save x = do
  f <- ask
  liftIO $ writeFile f (show x)

clearFile :: ReaderT FilePath IO ()
clearFile = save (M.empty::MetricHistory)

loadMetric :: MetricHistory -> String -> Metric
loadMetric db metricName = do
  case M.lookup metricName db of
    Nothing -> M.empty
    Just metric -> metric

addMetric :: String -> Int -> ReaderT FilePath IO MetricHistory
addMetric metricName count = do
  t <- liftIO today
  db <- load
  let innerMetric = loadMetric db metricName
      updatedMap = (M.insert metricName (M.insert t count innerMetric) db)
    in length updatedMap `seq` (save updatedMap >> load)

makeJson :: Metric -> String
makeJson = L.intercalate "," . map (\(date, cnt) -> "['" ++ date ++ "', " ++ (show cnt) ++ "]") . M.toAscList

generateJson :: String -> ReaderT FilePath IO String
generateJson metricName = do
  db <- load
  return $ makeJson $ loadMetric db metricName




