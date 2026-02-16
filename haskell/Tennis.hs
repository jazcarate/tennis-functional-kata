module Tennis where

data Game = Game
  { player1 :: Int
  , player2 :: Int
  }
data Point = P1 | P2

point :: Game -> Point -> Game
point game P1 = game { player1 = 1 + (player1 game) }
point game P2 = Game (player1 game) (succ (player2 game))

mkGame :: Game
mkGame = Game 0 0

score :: Game -> String
score x = toString (player1 x) <> " - " <> toString (player2 x)

toString :: Int -> String
toString 0 = "love"
toString 1 = "15"
toString 2 = "30"
toString 3 = "40"
toString _ = "?"


-- Simple test framework
data TestResult = Pass | Fail String deriving (Eq)

runTest :: String -> Bool -> IO ()
runTest name True = putStrLn $ "  ✓ " ++ name
runTest name False = putStrLn $ "  ✗ FAIL: " ++ name

testScore :: String -> [Point] -> String -> IO ()
testScore name points expected =
  let actual = score $ foldl point mkGame points
      passed = actual == expected
  in if passed
     then runTest name True
     else do
       runTest name False
       putStrLn $ "      Expected: " ++ expected
       putStrLn $ "           Got: " ++ actual

main :: IO ()
main = do
  putStrLn "Tennis Kata Tests"
  
  putStrLn "\nx - love:"
  testScore "starts with love" [] "love - love"
  testScore "a point is 15" [P1] "15 - love"
  testScore "two points is 30" [P1, P1] "30 - love"
  testScore "three points is 40" [P1, P1, P1] "40 - love"
  testScore "four points is game" [P1, P1, P1, P1] "Game P1"

  putStrLn "\nlove - x:"
  testScore "a point is 15" [P2] "love - 15"
  testScore "two points is 30" [P2, P2] "love - 30"
  testScore "three points is 40" [P2, P2, P2] "love - 40"
  testScore "four points is game" [P2, P2, P2, P2] "Game P2"

  putStrLn "\nx - 15:"
  let initial15_2 = [P2]
  testScore "starts with 15" initial15_2 "love - 15"
  testScore "a point is 15" (initial15_2 ++ [P1]) "15 - 15"
  testScore "two points is 30" (initial15_2 ++ [P1, P1]) "30 - 15"
  testScore "three points is 40" (initial15_2 ++ [P1, P1, P1]) "40 - 15"
  testScore "four points is game" (initial15_2 ++ [P1, P1, P1, P1]) "Game P1"

  putStrLn "\n15 - x:"
  let initial15_1 = [P1]
  testScore "starts with 15" initial15_1 "15 - love"
  testScore "a point is 15" (initial15_1 ++ [P2]) "15 - 15"
  testScore "two points is 30" (initial15_1 ++ [P2, P2]) "15 - 30"
  testScore "three points is 40" (initial15_1 ++ [P2, P2, P2]) "15 - 40"
  testScore "four points is game" (initial15_1 ++ [P2, P2, P2, P2]) "Game P2"

  putStrLn "\nx - 30:"
  let initial30_2 = [P2, P2]
  testScore "starts with 30" initial30_2 "love - 30"
  testScore "a point is 15" (initial30_2 ++ [P1]) "15 - 30"
  testScore "two points is 30" (initial30_2 ++ [P1, P1]) "30 - 30"
  testScore "three points is 40" (initial30_2 ++ [P1, P1, P1]) "40 - 30"
  testScore "four points is game" (initial30_2 ++ [P1, P1, P1, P1]) "Game P1"

  putStrLn "\n30 - x:"
  let initial30_1 = [P1, P1]
  testScore "starts with 30" initial30_1 "30 - love"
  testScore "a point is 15" (initial30_1 ++ [P2]) "30 - 15"
  testScore "two points is 30" (initial30_1 ++ [P2, P2]) "30 - 30"
  testScore "three points is 40" (initial30_1 ++ [P2, P2, P2]) "30 - 40"
  testScore "four points is game" (initial30_1 ++ [P2, P2, P2, P2]) "Game P2"

  putStrLn "\nx - 40:"
  let initial40_2 = [P2, P2, P2]
  testScore "starts with 40" initial40_2 "love - 40"
  testScore "a point is 15" (initial40_2 ++ [P1]) "15 - 40"
  testScore "two points is 30" (initial40_2 ++ [P1, P1]) "30 - 40"

  putStrLn "\n40 - x:"
  let initial40_1 = [P1, P1, P1]
  testScore "starts with 40" initial40_1 "40 - love"
  testScore "a point is 15" (initial40_1 ++ [P2]) "40 - 15"
  testScore "two points is 30" (initial40_1 ++ [P2, P2]) "40 - 30"

  putStrLn "\ndeuce:"
  let initialDeuce = [P1, P1, P1, P2, P2, P2]
  testScore "starts in deuce" initialDeuce "Deuce"
  testScore "p1 advantage" (initialDeuce ++ [P1]) "Advantage P1"
  testScore "p1 wins" (initialDeuce ++ [P1, P1]) "Game P1"
  testScore "p2 advantage" (initialDeuce ++ [P2]) "Advantage P2"
  testScore "p2 wins" (initialDeuce ++ [P2, P2]) "Game P2"
  testScore "loop back to deuce" (initialDeuce ++ [P2, P1]) "Deuce"
