module GameBoard.Board exposing (..)

import Html as Html
import Svg as Svg
import Svg.Attributes as SA
import Svg.Events as SE


-- Custom imports

import Messages exposing (Msg(..))


type Point
    = Point
        { x : Int
        , y : Int
        }


gameBoard : Html.Html Msg
gameBoard =
    Html.div []
        [ Html.p [] [ Html.text "board" ]
        , Svg.svg
            [ SA.width "120"
            , SA.height "120"
            , SA.viewBox "0 0 120 120"
            ]
            [ exploredSquare 0 (Point { x = 10, y = 30 })
            , exploredSquare 2 (Point { x = 25, y = 25 })
            , unexploredSquare (Point { x = 40, y = 40 })
            , flagSquare (Point { x = 50, y = 30 })
            , unknownSquare (Point { x = 60, y = 30 })
            , bombSquare (Point { x = 60, y = 10 })
            ]
        ]



-- svgStuff : Svg.Svg Msg
-- svgStuff =
--     Svg.rect
--         [ SA.x "10"
--         , SA.y "10"
--         , SA.width "10"
--         , SA.height "10"
--         , SA.rx "15"
--         , SA.ry "15"
--         ]
--         []


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
        ]
        []


unknownSquare : Point -> Svg.Svg Msg
unknownSquare point =
    Svg.g []
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
    case number of
        0 ->
            emptySquare point

        _ ->
            Svg.g []
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
