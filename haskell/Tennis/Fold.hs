{-# LANGUAGE LambdaCase #-}

module Tennis.Fold
  ( point,
    score,
    newGame,
    Player (..),
    Game,
  )
where

data Player = Player1 | Player2
  deriving (Eq, Show)

newtype Game = Game [Player]
  deriving (Eq, Show)

point :: Game -> Player -> Game
point (Game events) player = Game (events ++ [player])

newGame :: Game
newGame = Game []

score :: Game -> String
score (Game events) = scoreFromEvents events

data ScoreState
  = Regular Int Int
  | OneForty Player Int
  | InDeuce
  | HasAdvantage Player
  | GameWon Player
  deriving (Eq, Show)

scoreFromEvents :: [Player] -> String
scoreFromEvents = renderState . foldl transition (Regular 0 0)
  where
    transition :: ScoreState -> Player -> ScoreState
    transition state player = case (state, player) of
      (GameWon winner, _) -> GameWon winner
      (Regular p1 p2, Player1)
        | p1 < 2 -> Regular (p1 + 1) p2
        | p1 == 2 -> OneForty Player1 p2
      (Regular p1 p2, Player2)
        | p2 < 2 -> Regular p1 (p2 + 1)
        | p2 == 2 -> OneForty Player2 p1
      (OneForty Player1 p2, Player1) -> GameWon Player1
      (OneForty Player2 p1, Player2) -> GameWon Player2
      (OneForty Player1 p2, Player2)
        | p2 < 2 -> OneForty Player1 (p2 + 1)
        | p2 == 2 -> InDeuce
      (OneForty Player2 p1, Player1)
        | p1 < 2 -> OneForty Player2 (p1 + 1)
        | p1 == 2 -> InDeuce
      (InDeuce, Player1) -> HasAdvantage Player1
      (InDeuce, Player2) -> HasAdvantage Player2
      (HasAdvantage Player1, Player1) -> GameWon Player1
      (HasAdvantage Player2, Player2) -> GameWon Player2
      (HasAdvantage Player1, Player2) -> InDeuce
      (HasAdvantage Player2, Player1) -> InDeuce
      _ -> state

renderState :: ScoreState -> String
renderState = \case
  Regular p1 p2 -> pointsToString p1 <> " - " <> pointsToString p2
  OneForty Player1 p2 -> "40 - " <> pointsToString p2
  OneForty Player2 p1 -> pointsToString p1 <> " - 40"
  InDeuce -> "Deuce"
  HasAdvantage Player1 -> "Advantage P1"
  HasAdvantage Player2 -> "Advantage P2"
  GameWon Player1 -> "Game P1"
  GameWon Player2 -> "Game P2"

pointsToString :: Int -> String
pointsToString 0 = "love"
pointsToString 1 = "15"
pointsToString 2 = "30"
pointsToString _ = "?"
