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
            ( isClicked gameBoard coord direction, Cmd.none )



-- let
--     square =
--         Dict.get coord gameBoard
-- in
--     case square of
--         Just (Uninitialized tag) ->
--             ( gameBoard, Cmd.none )
--         _ ->
--             ( isClicked gameBoard coord direction, Cmd.none )


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
                case s of
                    Uninitialized _ ->
                        uninitializedClicked board coord

                    _ ->
                        Dict.insert coord (squareLeftClicked s) board

            Nothing ->
                board


uninitializedClicked : Board -> Coord -> Board
uninitializedClicked board coord =
    let
        positions =
            [ ( 0, -1 )
            , ( 0, 1 )
            , ( 1, -1 )
            , ( 1, 0 )
            , ( 1, 1 )
            , ( -1, -1 )
            , ( -1, 0 )
            , ( -1, 1 )
            ]

        sumTuple x y =
            ( (Tuple.first x) + (Tuple.first y), (Tuple.second x) + (Tuple.second y) )

        squareValue =
            List.foldl (\x y -> x + y)
                0
                (List.map
                    (\x -> getSquareValue board (sumTuple coord x))
                    positions
                )
    in
        case squareValue of
            0 ->
                -- List.map (\x -> uninitializedClicked board (sumTuple coord x)) positions
                let
                    l =
                        List.head positions
                in
                    case l of
                        Just c ->
                            -- uninitializedClicked (Dict.insert coord (Explored (Bombs squareValue)) board) (sumTuple coord c)
                            Dict.insert coord (Explored (Bombs squareValue)) board

                        Nothing ->
                            Dict.insert coord (Explored (Bombs squareValue)) board

            _ ->
                Dict.insert coord (Explored (Bombs squareValue)) board


getSquareValue : Board -> Coord -> Int
getSquareValue board coord =
    let
        s =
            Dict.get coord board
    in
        case s of
            Just s ->
                case s of
                    Unexplored IsBomb _ ->
                        1

                    Explored IsBomb ->
                        0

                    _ ->
                        0

            Nothing ->
                0


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
