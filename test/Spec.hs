import Test.HUnit
import qualified Lib as S

main :: IO ()
main = do
  x <- runTestTT tests
  return ()

identifier :: Assertion
identifier = do
  a <- S.countGrepRepo "Identifier"
  a @?= 4

save :: Assertion
save = do
  a <- S.countGrepRepo ".Save("
  a @?= 2

findAll :: Assertion
findAll = do
  a <- S.countGrepRepo ".FindAll("
  a @?= 2

find :: Assertion
find = do
  a <- S.countGrepRepo ".Find("
  a @?= 2

tests = TestList ["save" ~: save 
                  , "findall" ~: findAll 
                  , "find" ~: find 
                  , "identifier" ~: identifier]

