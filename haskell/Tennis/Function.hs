{-# LANGUAGE LambdaCase #-}

module Tennis.Function
  ( point,
    score,
    newGame,
    Player (..),
    Game,
  )
where

data Player = Player1 | Player2
  deriving (Eq, Show)

data Game = Game String (Player -> Game)

point :: Game -> Player -> Game
point (Game _ transition) = transition

score :: Game -> String
score (Game currentScore _) = currentScore

newGame :: Game
newGame = regularScore 0 0

regularScore :: Int -> Int -> Game
regularScore p1 p2
  | p1 >= 3 && p2 >= 3 = deuce
  | p1 >= 3 = fortyScore Player1 p2
  | p2 >= 3 = fortyScore Player2 p1
  | otherwise = Game (showRegular p1 p2) $ \case
      Player1 -> regularScore (p1 + 1) p2
      Player2 -> regularScore p1 (p2 + 1)

fortyScore :: Player -> Int -> Game
fortyScore leader catchupPoints =
  Game (showForty leader catchupPoints) $ \case
    player
      | player == leader ->
          wonGame leader
    _
      | catchupPoints < 2 ->
          fortyScore leader (catchupPoints + 1)
    _ ->
      deuce

deuce :: Game
deuce = Game "Deuce" $ \case
  Player1 -> advantage Player1
  Player2 -> advantage Player2

advantage :: Player -> Game
advantage player = Game ("Advantage " <> showPlayer player) $ \case
  scorer | scorer == player -> wonGame player
  _ -> deuce

wonGame :: Player -> Game
wonGame player =
  let msg = "Game " <> showPlayer player
   in Game msg (const (wonGame player))

showRegular :: Int -> Int -> String
showRegular p1 p2 = pointToString p1 <> " - " <> pointToString p2

showForty :: Player -> Int -> String
showForty Player1 p2 = "40 - " <> pointToString p2
showForty Player2 p1 = pointToString p1 <> " - 40"

pointToString :: Int -> String
pointToString 0 = "love"
pointToString 1 = "15"
pointToString 2 = "30"
pointToString 3 = "40"
pointToString _ = "?"

showPlayer :: Player -> String
showPlayer Player1 = "P1"
showPlayer Player2 = "P2"
