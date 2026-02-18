module Main where

import Tennis

data TestResult = Pass | Fail String deriving (Eq)

scoreSequence :: [Player] -> Game
scoreSequence = foldl point newGame

runTest :: String -> Bool -> IO ()
runTest name True = putStrLn $ "  ✓ " ++ name
runTest name False = putStrLn $ "  ✗ FAIL: " ++ name

testScore :: String -> [Player] -> String -> IO ()
testScore name players expected =
  let actual = score $ scoreSequence players
      passed = actual == expected
   in if passed
        then runTest name True
        else do
          runTest name False
          putStrLn $ "      Expected: " ++ expected
          putStrLn $ "           Got: " ++ actual

main :: IO ()
main = do
  putStrLn "Player 1 scoring:"
  testScore "starts with love" [] "love - love"
  testScore "Player1 scores once" [Player1] "15 - love"
  testScore "Player1 scores twice" [Player1, Player1] "30 - love"
  testScore "Player1 scores thrice" [Player1, Player1, Player1] "40 - love"
  testScore "Player1 wins" [Player1, Player1, Player1, Player1] "Game P1"

  putStrLn "\nPlayer 2 scoring:"
  testScore "Player2 scores once" [Player2] "love - 15"
  testScore "Player2 scores twice" [Player2, Player2] "love - 30"
  testScore "Player2 scores thrice" [Player2, Player2, Player2] "love - 40"
  testScore "Player2 wins" [Player2, Player2, Player2, Player2] "Game P2"

  putStrLn "\nMixed scoring:"
  testScore "15-15" [Player1, Player2] "15 - 15"
  testScore "30-15" [Player1, Player1, Player2] "30 - 15"
  testScore "15-30" [Player1, Player2, Player2] "15 - 30"
  testScore "40-30" [Player1, Player1, Player1, Player2, Player2] "40 - 30"
  testScore "30-40" [Player1, Player1, Player2, Player2, Player2] "30 - 40"

  putStrLn "\nDeuce scenarios:"
  let toDeuce = [Player1, Player1, Player1, Player2, Player2, Player2]
  testScore "reach deuce" toDeuce "Deuce"
  testScore "Player1 advantage" (toDeuce ++ [Player1]) "Advantage P1"
  testScore "Player1 wins from advantage" (toDeuce ++ [Player1, Player1]) "Game P1"
  testScore "Player2 advantage" (toDeuce ++ [Player2]) "Advantage P2"
  testScore "Player2 wins from advantage" (toDeuce ++ [Player2, Player2]) "Game P2"
  testScore "back to deuce from adv" (toDeuce ++ [Player1, Player2]) "Deuce"
  testScore "deuce loop" (toDeuce ++ [Player1, Player2, Player2, Player1]) "Deuce"

  putStrLn "\nDeuce stress tests:"
  testScore "long deuce rally - 5 loops back to deuce"
    (toDeuce ++ [Player1, Player2, Player1, Player2, Player1, Player2, Player1, Player2, Player1, Player2])
    "Deuce"
  testScore "10 deuce loops then P1 advantage"
    (toDeuce ++ concat (replicate 10 [Player1, Player2]) ++ [Player1])
    "Advantage P1"
  testScore "10 deuce loops then P1 wins"
    (toDeuce ++ concat (replicate 10 [Player1, Player2]) ++ [Player1, Player1])
    "Game P1"
  testScore "alternating advantages then P2 wins"
    (toDeuce ++ [Player1, Player2, Player2, Player1, Player1, Player2, Player2, Player2])
    "Game P2"
  testScore "P1 advantage, back to deuce, P2 advantage, back to deuce"
    (toDeuce ++ [Player1, Player2, Player2, Player1])
    "Deuce"
  testScore "many advantages for P1, then P2 catches up and wins"
    (toDeuce ++ [Player1, Player2, Player1, Player2, Player1, Player2, Player2, Player2])
    "Game P2"
