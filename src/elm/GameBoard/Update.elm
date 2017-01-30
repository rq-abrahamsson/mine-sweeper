module GameBoard.Update exposing (..)

import Dict


-- Custom imports

import GameBoard.Messages exposing (Msg(..))
import GameBoard.Models exposing (..)


update : Msg -> Board -> ( Board, Cmd Msg )
update message gameBoard =
    case message of
        InitBoard ->
            ( gameBoard, Cmd.none )

        SquareClicked coord ->
            ( clicked gameBoard coord, Cmd.none )


clicked : Board -> Coord -> Board
clicked board coord =
    let
        square =
            Dict.get coord board
    in
        case square of
            Just s ->
                Dict.insert coord (squareClicked s) board

            Nothing ->
                board


squareClicked : Square -> Square
squareClicked square =
    case square of
        Unexplored x None ->
            Explored x

        Unexplored x Flag ->
            square

        Unexplored x QuestionMark ->
            square

        _ ->
            square
