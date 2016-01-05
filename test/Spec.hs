import Test.HUnit
import qualified Lib as S
import Data.Functor ((<$>))

main :: IO ()
main = do
  x <- runTestTT tests
  return ()

identifier :: Assertion
identifier = S.identifierCount >>= (@?= 4)

save :: Assertion
save = S.saveCount >>= (@?= 2)

findAll :: Assertion
findAll = S.findAllCount >>= (@?= 2)

find :: Assertion
find = S.findCount >>= (@?= 2)

tests = TestList ["save" ~: save
                  , "findall" ~: findAll
                  , "find" ~: find
                  , "identifier" ~: identifier]

