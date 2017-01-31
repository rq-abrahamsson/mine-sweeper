module GameBoard.Messages exposing (..)

import GameBoard.Models exposing (Coord)


type Msg
    = InitBoard
    | RightClick Coord
    | SquareClicked Coord
