module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- Custom imports

import GameBoard.Models exposing (Board, boardModel)
import GameBoard.GameBoard exposing (gameBoard)
import GameBoard.Update
import Messages exposing (Msg(..))


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { board : Board
    }


model : Model
model =
    { board = boardModel
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InitBoard ->
            ( { model | board = boardModel }, Cmd.none )

        GameBoardMsg subMsg ->
            let
                ( updatedGameBoard, cmd ) =
                    GameBoard.Update.update subMsg model.board
            in
                ( { model | board = updatedGameBoard }, Cmd.map GameBoardMsg cmd )



-- VIEW


view : Model -> Html Msg
view model =
    div [ style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div []
            [ button [ onClick InitBoard ] [ span [] [ text "Init board" ] ]
            , Html.map GameBoardMsg (gameBoard model.board)
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "33%" )
        , ( "border", "4px solid #337AB7" )
        ]
    }
