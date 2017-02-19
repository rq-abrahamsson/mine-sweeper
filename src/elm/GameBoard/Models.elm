module GameBoard.Models exposing (..)

import Dict


type Direction
    = Left
    | Right


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
    | Uninitialized Tag
    | Explored BombsNearby


generateBoard : Int -> Board
generateBoard size =
    let
        l =
            List.range 1 size
    in
        Dict.fromList
            (List.concatMap
                (\e -> e)
                (List.map
                    (\e1 ->
                        List.map
                            (\e2 ->
                                ( ( e1, e2 ), Uninitialized None )
                            )
                            l
                    )
                    l
                )
            )


boardModel : Board
boardModel =
    Dict.fromList
        [ ( ( 0, 0 ), Unexplored IsBomb None )
        , ( ( 0, 1 ), Unexplored (Bombs 1) None )
        , ( ( 1, 0 ), Unexplored (Bombs 1) Flag )
        , ( ( 1, 1 ), Unexplored (Bombs 1) QuestionMark )
        , ( ( 1, 2 ), Explored (Bombs 0) )
        , ( ( 1, 3 ), Explored (Bombs 1) )
        , ( ( 1, 4 ), Explored (IsBomb) )
        , ( ( 1, 5 ), Uninitialized None )
        ]


testBoard : Board
testBoard =
    Dict.fromList
        [ ( ( 0, 0 ), Unexplored IsBomb Flag )
        , ( ( 0, 1 ), Uninitialized None )
        , ( ( 0, 2 ), Uninitialized None )
        , ( ( 0, 3 ), Uninitialized None )
        , ( ( 0, 4 ), Uninitialized None )
        , ( ( 1, 0 ), Unexplored IsBomb Flag )
        , ( ( 1, 1 ), Uninitialized None )
        , ( ( 1, 2 ), Uninitialized None )
        , ( ( 1, 3 ), Uninitialized None )
        , ( ( 1, 4 ), Uninitialized None )
        , ( ( 2, 0 ), Uninitialized None )
        , ( ( 2, 1 ), Uninitialized None )
        , ( ( 2, 2 ), Unexplored IsBomb Flag )
        , ( ( 2, 3 ), Uninitialized None )
        , ( ( 2, 4 ), Uninitialized None )
        , ( ( 3, 0 ), Uninitialized None )
        , ( ( 3, 1 ), Uninitialized None )
        , ( ( 3, 2 ), Unexplored IsBomb Flag )
        , ( ( 3, 3 ), Uninitialized None )
        , ( ( 3, 4 ), Uninitialized None )
        , ( ( 4, 0 ), Uninitialized None )
        , ( ( 4, 1 ), Uninitialized None )
        , ( ( 4, 2 ), Unexplored IsBomb Flag )
        , ( ( 4, 3 ), Uninitialized None )
        , ( ( 4, 4 ), Uninitialized None )
        ]
