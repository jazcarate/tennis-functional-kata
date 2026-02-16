{-# LANGUAGE LambdaCase #-}
module Tennis where

data Player = Player1 | Player2
  deriving (Eq, Show)

data Points = Love | Fifteen | Thirty
  deriving (Eq, Show)

data Game
  = Points Points Points
  | FortyThirty Player Points
  | Deuce
  | Advantage Player
  | Won Player
  deriving (Eq, Show)

point :: Game -> Player -> Game
point game player = case (game, player) of
  (Won winner, _) -> Won winner

  (Points p1 p2, Player1) -> case p1 of
    Love    -> Points Fifteen p2
    Fifteen -> Points Thirty p2
    Thirty  -> FortyThirty Player1 p2

  (Points p1 p2, Player2) -> case p2 of
    Love    -> Points p1 Fifteen
    Fifteen -> Points p1 Thirty
    Thirty  -> FortyThirty Player2 p1

  (FortyThirty Player1 p2, Player1) -> Won Player1
  (FortyThirty Player2 p1, Player2) -> Won Player2

  (FortyThirty Player1 Love, Player2)    -> FortyThirty Player1 Fifteen
  (FortyThirty Player1 Fifteen, Player2) -> FortyThirty Player1 Thirty
  (FortyThirty Player1 Thirty, Player2)  -> Deuce

  (FortyThirty Player2 Love, Player1)    -> FortyThirty Player2 Fifteen
  (FortyThirty Player2 Fifteen, Player1) -> FortyThirty Player2 Thirty
  (FortyThirty Player2 Thirty, Player1)  -> Deuce

  (Deuce, Player1) -> Advantage Player1
  (Deuce, Player2) -> Advantage Player2

  (Advantage Player1, Player1) -> Won Player1
  (Advantage Player2, Player2) -> Won Player2
  (Advantage Player1, Player2) -> Deuce
  (Advantage Player2, Player1) -> Deuce

newGame :: Game
newGame = Points Love Love

score :: Game -> String
score = \case
  Points p1 p2 -> showPoints p1 <> " - " <> showPoints p2
  FortyThirty Player1 p2 -> "40 - " <> showPoints p2
  FortyThirty Player2 p1 -> showPoints p1 <> " - 40"
  Deuce -> "Deuce"
  Advantage Player1 -> "Advantage P1"
  Advantage Player2 -> "Advantage P2"
  Won Player1 -> "Game P1"
  Won Player2 -> "Game P2"

showPoints :: Points -> String
showPoints = \case
  Love    -> "love"
  Fifteen -> "15"
  Thirty  -> "30"


-- Test --

data TestResult = Pass | Fail String deriving (Eq)

scoreSequence :: [Player] -> Game
scoreSequence = foldl point newGame

runTest :: String -> Bool -> IO ()
runTest name True  = putStrLn $ "  ✓ " ++ name
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

p1, p2 :: Player
p1 = Player1
p2 = Player2

main :: IO ()
main = do
  putStrLn "Basic scoring:"
  testScore "starts with love" [] "love - love"
  testScore "p1 scores once" [p1] "15 - love"
  testScore "p1 scores twice" [p1, p1] "30 - love"
  testScore "p1 scores thrice" [p1, p1, p1] "40 - love"
  testScore "p1 wins" [p1, p1, p1, p1] "Game P1"

  putStrLn "\nPlayer 2 scoring:"
  testScore "p2 scores once" [p2] "love - 15"
  testScore "p2 scores twice" [p2, p2] "love - 30"
  testScore "p2 scores thrice" [p2, p2, p2] "love - 40"
  testScore "p2 wins" [p2, p2, p2, p2] "Game P2"

  putStrLn "\nMixed scoring:"
  testScore "15-15" [p1, p2] "15 - 15"
  testScore "30-15" [p1, p1, p2] "30 - 15"
  testScore "15-30" [p1, p2, p2] "15 - 30"
  testScore "40-30" [p1, p1, p1, p2, p2] "40 - 30"
  testScore "30-40" [p1, p1, p2, p2, p2] "30 - 40"

  putStrLn "\nDeuce scenarios:"
  let toDeuce = [p1, p1, p1, p2, p2, p2]
  testScore "reach deuce" toDeuce "Deuce"
  testScore "p1 advantage" (toDeuce ++ [p1]) "Advantage P1"
  testScore "p1 wins from advantage" (toDeuce ++ [p1, p1]) "Game P1"
  testScore "p2 advantage" (toDeuce ++ [p2]) "Advantage P2"
  testScore "p2 wins from advantage" (toDeuce ++ [p2, p2]) "Game P2"
  testScore "back to deuce from adv" (toDeuce ++ [p1, p2]) "Deuce"
  testScore "deuce loop" (toDeuce ++ [p1, p2, p2, p1]) "Deuce"