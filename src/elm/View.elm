module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- Custom imports

import Messages exposing (Msg(..))
import GameBoard.GameBoard exposing (gameBoard)
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div [ style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div []
            [ button [ onClick InitBoard ] [ span [] [ text "Init board" ] ]
            , Html.map GameBoardMsg (gameBoard model.board)
            ]
        ]
