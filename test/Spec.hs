import Test.HUnit
import qualified Lib as S

main :: IO ()
main = do
  x <- runTestTT tests
  return ()

a2 :: Assertion
a2 = do
  a <- S.grepRepo "test"
  (a @?= 2)

a1 :: Assertion
a1 = do
  a <- S.grepRepo "test"
  (a @?= 2)

test2 = "test2" ~: a1 >> a2

tests = TestList [test2]

