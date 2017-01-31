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
            , SA.style "cursor: pointer"
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


drawSquare : ( Coord, Square ) -> Svg.Svg Msg
drawSquare ( coord, square ) =
    let
        ( x, y ) =
            coord
    in
        case square of
            Unexplored _ Flag ->
                flagSquare (Point { x = x * 11, y = y * 11 })

            Unexplored _ QuestionMark ->
                unknownSquare (Point { x = x * 11, y = y * 11 })

            Unexplored _ None ->
                unexploredSquare (Point { x = x * 11, y = y * 11 })

            Explored (Bombs number) ->
                exploredSquare number (Point { x = x * 11, y = y * 11 })

            Explored IsBomb ->
                bombSquare (Point { x = x * 11, y = y * 11 })


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
        [ SA.width "10"
        , SA.height "10"
        , SA.x <| toString x
        , SA.y <| toString y
        , SA.fill "red"
        , SA.stroke "#333"
        , SA.opacity "0.5"
        , onRightClick
            (RightClick
                ( round (toFloat (x) / 10)
                , round (toFloat (y) / 10)
                )
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
                    ( round (toFloat (x) / 10)
                    , round (toFloat (y) / 10)
                    )
                )
            ]
            [ unexploredSquare point
            , getQuestionmark point
            ]


getQuestionmark : Point -> Svg.Svg Msg
getQuestionmark (Point { x, y }) =
    Svg.text_
        [ SA.x <| toString <| x + 2
        , SA.y <| toString <| y + 10
        , SA.color "black"
        , SA.fontSize "13"
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
                            ( round (toFloat (x) / 10)
                            , round (toFloat (y) / 10)
                            )
                        )
                    ]
                    [ emptySquare point
                    , svgNumber number point
                    ]


emptySquare : Point -> Svg.Svg Msg
emptySquare (Point { x, y }) =
    Svg.rect
        [ SA.width "10"
        , SA.height "10"
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
        [ SA.x <| toString <| x + 2
        , SA.y <| toString <| y + 10
        , SA.color "black"
        , SA.fontSize "13"
        ]
        [ Svg.text (toString number) ]


unexploredSquare : Point -> Svg.Svg Msg
unexploredSquare (Point { x, y }) =
    Svg.rect
        [ SA.width "10"
        , SA.height "10"
        , SA.x <| toString x
        , SA.y <| toString y
        , SA.fill "#555"
        , SA.stroke "#888"
        , SA.opacity "0.5"
        , SE.onClick
            (SquareClicked
                ( round (toFloat (x) / 10)
                , round (toFloat (y) / 10)
                )
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
        left =
            toString (x + 2) ++ "," ++ toString (toFloat (y) + 2.5)

        topRight =
            toString (x + 8) ++ "," ++ toString (y)

        bottomRight =
            toString (x + 8) ++ "," ++ toString (y + 5)

        poleStart =
            toString (x + 8) ++ "," ++ toString (y + 8)

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
                [ SA.x1 (toString (x + 8))
                , SA.y1 (toString (y))
                , SA.x2 (toString (x + 8))
                , SA.y2 (toString (y + 9))
                , SA.strokeWidth "1"
                , SA.stroke "black"
                ]
                []
            ]
