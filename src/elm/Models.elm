module Models exposing (..)

--Custom imports

import GameBoard.Models exposing (Board, boardModel, generateBoard, testBoard)


type alias Model =
    { board : Board
    }


model : Model
model =
    { board =
        testBoard
    }
