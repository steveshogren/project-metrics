import Test.HUnit
import qualified Grep as G
import Data.Functor ((<$>))

main :: IO ()
main = do
  x <- runTestTT tests
  return ()

identifier :: Assertion
identifier = G.identifierCount >>= (@?= 4)

save :: Assertion
save = G.saveCount >>= (@?= 2)

findAll :: Assertion
findAll = G.findAllCount >>= (@?= 2)

find :: Assertion
find = G.findCount >>= (@?= 2)

tests = TestList ["save" ~: save
                  , "findall" ~: findAll
                  , "find" ~: find
                  , "identifier" ~: identifier]

