module GameBoard.GameBoard exposing (..)

import Html as Html
import Html.Events as HE
import Svg as Svg
import Svg.Attributes as SA
import Svg.Events as SE
import Dict
import Json.Decode as Json


-- Custom imports

import GameBoard.Messages exposing (..)
import GameBoard.Models exposing (..)


gameBoard : Board -> Html.Html Msg
gameBoard board =
    Html.div []
        [ Html.p [] [ Html.text "board" ]
        , Svg.svg
            [ SA.width "220"
            , SA.height "220"
            , SA.viewBox "0 0 220 220"
              --, SA.style "cursor: pointer"
            , SA.style "cursor: default"
            ]
            [ drawSquares board
            ]
        ]


drawSquares : Board -> Svg.Svg Msg
drawSquares board =
    Svg.g []
        (List.map
            drawSquare
            (Dict.toList board)
        )


size : number
size =
    15


scale : number
scale =
    size + 1


drawSquare : ( Coord, Square ) -> Svg.Svg Msg
drawSquare ( coord, square ) =
    let
        ( x, y ) =
            coord

        point =
            (Point { x = x * scale, y = y * scale })
    in
        case square of
            Uninitialized None ->
                unexploredSquare point

            Uninitialized Flag ->
                flagSquare point

            Uninitialized QuestionMark ->
                unknownSquare point

            Unexplored _ None ->
                unexploredSquare point

            Unexplored _ Flag ->
                flagSquare point

            Unexplored _ QuestionMark ->
                unknownSquare point

            Explored (Bombs number) ->
                exploredSquare number point

            Explored IsBomb ->
                bombSquare point


onRightClick : a -> Html.Attribute a
onRightClick message =
    HE.onWithOptions
        "contextmenu"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.succeed message)


bombSquare : Point -> Svg.Svg Msg
bombSquare (Point { x, y }) =
    Svg.rect
        [ SA.width <| toString <| size
        , SA.height <| toString <| size
        , SA.x <| toString x
        , SA.y <| toString y
        , SA.fill "red"
        , SA.stroke "#333"
        , SA.opacity "0.5"
        , SE.onClick
            (SquareClicked
                ( round (toFloat (x) / scale)
                , round (toFloat (y) / scale)
                )
                Left
            )
        , onRightClick
            (SquareClicked
                ( round (toFloat (x) / scale)
                , round (toFloat (y) / scale)
                )
                Right
            )
        ]
        []


unknownSquare : Point -> Svg.Svg Msg
unknownSquare point =
    let
        (Point { x, y }) =
            point
    in
        Svg.g
            [ SE.onClick
                (SquareClicked
                    ( round (toFloat (x) / scale)
                    , round (toFloat (y) / scale)
                    )
                    Left
                )
            , onRightClick
                (SquareClicked
                    ( round (toFloat (x) / scale)
                    , round (toFloat (y) / scale)
                    )
                    Right
                )
            ]
            [ unexploredSquare point
            , getQuestionmark point
            ]


getQuestionmark : Point -> Svg.Svg Msg
getQuestionmark (Point { x, y }) =
    Svg.text_
        [ SA.x <| toString <| x + round (size / 5)
        , SA.y <| toString <| y + size
        , SA.color "black"
        , SA.fontSize <| toString (size + 3)
        , SA.style "user-select: none;"
        ]
        [ Svg.text "?" ]


exploredSquare : Int -> Point -> Svg.Svg Msg
exploredSquare number point =
    let
        (Point { x, y }) =
            point
    in
        case number of
            0 ->
                emptySquare point

            _ ->
                Svg.g
                    [ SE.onClick
                        (SquareClicked
                            ( round (toFloat (x) / scale)
                            , round (toFloat (y) / scale)
                            )
                            Left
                        )
                    , onRightClick
                        (SquareClicked
                            ( round (toFloat (x) / scale)
                            , round (toFloat (y) / scale)
                            )
                            Right
                        )
                    ]
                    [ emptySquare point
                    , svgNumber number point
                    ]


emptySquare : Point -> Svg.Svg Msg
emptySquare (Point { x, y }) =
    Svg.rect
        [ SA.width <| toString <| size
        , SA.height <| toString <| size
        , SA.x <| toString x
        , SA.y <| toString y
        , SA.fill "#aaa"
        , SA.stroke "#333"
        , SA.opacity "0.5"
        ]
        []


svgNumber : Int -> Point -> Svg.Svg Msg
svgNumber number (Point { x, y }) =
    Svg.text_
        [ SA.x <| toString <| x + round (size / 5)
        , SA.y <| toString <| y + size
        , SA.color "black"
        , SA.fontSize <| toString (size + 3)
        , SA.style "user-select: none;"
        ]
        [ Svg.text (toString number) ]


unexploredSquare : Point -> Svg.Svg Msg
unexploredSquare (Point { x, y }) =
    Svg.rect
        [ SA.width <| toString <| size
        , SA.height <| toString <| size
        , SA.x <| toString x
        , SA.y <| toString y
        , SA.fill "#555"
        , SA.stroke "#888"
        , SA.opacity "0.5"
        , SE.onClick
            (SquareClicked
                ( round (toFloat (x) / scale)
                , round (toFloat (y) / scale)
                )
                Left
            )
        , onRightClick
            (SquareClicked
                ( round (toFloat (x) / scale)
                , round (toFloat (y) / scale)
                )
                Right
            )
        ]
        []


flagSquare : Point -> Svg.Svg Msg
flagSquare point =
    Svg.g []
        [ unexploredSquare point
        , flag point
        ]


flag : Point -> Svg.Svg Msg
flag (Point { x, y }) =
    let
        closeleft =
            size / 5

        closeRight =
            size - (size / 5)

        left =
            toString (toFloat x + closeleft) ++ "," ++ toString (toFloat y + (size / 4))

        topRight =
            toString (toFloat x + closeRight) ++ "," ++ toString (y)

        bottomRight =
            toString (toFloat x + closeRight) ++ "," ++ toString (toFloat y + (size / 2))

        poleStart =
            toString (toFloat x + closeRight) ++ "," ++ toString (toFloat y + closeRight)

        flagPoints =
            left ++ " " ++ topRight ++ " " ++ bottomRight
    in
        Svg.g []
            [ Svg.polygon
                [ SA.points flagPoints
                , SA.fill "red"
                , SA.stroke "black"
                ]
                []
            , Svg.line
                [ SA.x1 (toString (toFloat x + closeRight))
                , SA.y1 (toString (y))
                , SA.x2 (toString (toFloat x + closeRight))
                , SA.y2 (toString (y + size - 1))
                , SA.strokeWidth "1"
                , SA.stroke "black"
                ]
                []
            ]
