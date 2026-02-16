{-# LANGUAGE LambdaCase #-}
module Tennis
  ( point
  , score
  , newGame
  , Player(..)
  , Game
  ) where

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
