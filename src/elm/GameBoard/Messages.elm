module GameBoard.Messages exposing (..)

import GameBoard.Models exposing (Coord, Direction)


type Msg
    = InitBoard
      -- | RightClick Coord
    | SquareClicked Coord Direction
