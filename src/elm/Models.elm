module Models exposing (..)

--Custom imports

import GameBoard.Models exposing (Board, boardModel, generateBoard)


type alias Model =
    { board : Board
    }


model : Model
model =
    { board =
        generateBoard 10
    }
