module GameBoard.Update exposing (..)

import GameBoard.Messages exposing (Msg(..))
import GameBoard.Models exposing (..)


update : Msg -> Board -> ( Board, Cmd Msg )
update message gameBoard =
    case message of
        InitBoard ->
            ( gameBoard, Cmd.none )

        SquareClicked coord ->
            ( gameBoard, Cmd.none )
