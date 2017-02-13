module Models exposing (..)

--Custom imports

import GameBoard.Models exposing (Board, boardModel, generateModel)


type alias Model =
    { board : Board
    }


model : Model
model =
    { board =
        generateModel 10
    }
