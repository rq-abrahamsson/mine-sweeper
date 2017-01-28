module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- Custom imports

import GameBoard.Board as Board
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
    { number : Int
    }


model : Model
model =
    { number = 0
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

        Increment ->
            ( { model | number = model.number + 1 }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div []
            [ Board.gameBoard
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
