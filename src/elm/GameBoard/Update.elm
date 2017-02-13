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

        SquareClicked coord direction ->
            let
                square =
                    Dict.get coord gameBoard
            in
                case square of
                    Just (Uninitialized tag) ->
                        ( gameBoard, Cmd.none )

                    _ ->
                        ( isClicked gameBoard coord direction, Cmd.none )


isClicked : Board -> Coord -> Direction -> Board
isClicked board coord dir =
    case dir of
        Right ->
            rightClicked board coord

        Left ->
            leftClicked board coord


leftClicked : Board -> Coord -> Board
leftClicked board coord =
    let
        square =
            Dict.get coord board
    in
        case square of
            Just s ->
                Dict.insert coord (squareLeftClicked s) board

            Nothing ->
                board


squareLeftClicked : Square -> Square
squareLeftClicked square =
    case square of
        Unexplored x None ->
            Explored x

        Unexplored x Flag ->
            square

        Unexplored x QuestionMark ->
            square

        _ ->
            square


rightClicked : Board -> Coord -> Board
rightClicked board coord =
    let
        square =
            Dict.get coord board
    in
        case square of
            Just s ->
                Dict.insert coord (squareRightClicked s) board

            Nothing ->
                board


squareRightClicked : Square -> Square
squareRightClicked square =
    case square of
        Explored x ->
            Unexplored x None

        _ ->
            square
