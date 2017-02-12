module Main exposing (..)

import Html exposing (..)


-- Custom imports

import View exposing (view)
import Models exposing (..)
import Messages exposing (Msg(..))
import Update exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
