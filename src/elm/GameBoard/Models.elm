module GameBoard.Models exposing (..)

import Dict


type Point
    = Point
        { x : Int
        , y : Int
        }


type alias Coord =
    ( Int, Int )


type Tag
    = Flag
    | QuestionMark
    | None


type BombsNearby
    = Bombs Int
    | IsBomb


type alias Board =
    Dict.Dict Coord Square


type Square
    = Unexplored BombsNearby Tag
    | Explored BombsNearby


boardModel : Dict.Dict Coord Square
boardModel =
    Dict.fromList
        [ ( ( 0, 0 ), Unexplored IsBomb None )
        , ( ( 0, 1 ), Unexplored (Bombs 1) None )
        , ( ( 1, 0 ), Unexplored (Bombs 1) Flag )
        , ( ( 1, 1 ), Unexplored (Bombs 1) QuestionMark )
        , ( ( 1, 2 ), Explored (Bombs 0) )
        , ( ( 1, 3 ), Explored (Bombs 1) )
        , ( ( 1, 4 ), Explored (IsBomb) )
        ]