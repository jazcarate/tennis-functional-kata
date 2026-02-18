module Tennis.Lens
  ( point,
    score,
    newGame,
    Player (..),
    Game,
  )
where

import Control.Applicative (Alternative ((<|>)))
import Data.Maybe (fromJust)
import Data.Semigroup ((<>))

data Player = Player1 | Player2
  deriving (Eq, Show)

data Game = Game Int Int
  deriving (Eq, Show)

point :: Game -> Player -> Game
point (Game p1 p2) player =
  case player of
    Player1 -> Game (p1 + 1) p2
    Player2 -> Game p1 (p2 + 1)

newGame :: Game
newGame = Game 0 0

newtype View = View {runView :: Game -> Maybe String}

instance Semigroup View where
  View f <> View g = View $ \game -> f game <|> g game

score :: Game -> String
score = fromJust . runView (wonView <> deuceView <> regularView)

wonView :: View
wonView = View $ \(Game p1 p2) ->
  if p1 >= 4 && p1 - p2 >= 2
    then Just "Game P1"
    else
      if p2 >= 4 && p2 - p1 >= 2
        then Just "Game P2"
        else Nothing

deuceView :: View
deuceView = View $ \(Game p1 p2) ->
  if p1 >= 3 && p2 >= 3
    then Just $ case compare p1 p2 of
      EQ -> "Deuce"
      GT -> "Advantage P1"
      LT -> "Advantage P2"
    else Nothing

regularView :: View
regularView = View $ \(Game p1 p2) ->
  Just $ pointsToString p1 <> " - " <> pointsToString p2

pointsToString :: Int -> String
pointsToString 0 = "love"
pointsToString 1 = "15"
pointsToString 2 = "30"
pointsToString 3 = "40"
pointsToString _ = "?"
