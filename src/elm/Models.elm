module Models exposing (..)

--Custom imports

import GameBoard.Models exposing (Board, boardModel)


type alias Model =
    { board : Board
    }


model : Model
model =
    { board = boardModel
    }
