import Test.HUnit
import qualified Lib as S

main :: IO ()
main = do
  x <- runTestTT tests
  return ()

a2 :: Assertion
a2 = do
  a <- S.grepRepo "Identifier"
  a @?= 4

a1 :: Assertion
a1 = 2 @?= 2

tests = TestList ["test2" ~: a2]

