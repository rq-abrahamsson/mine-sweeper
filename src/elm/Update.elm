module Update exposing (..)

--Custom imports

import GameBoard.Update
import Models exposing (..)
import Messages exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InitBoard ->
            ( model, Cmd.none )

        GameBoardMsg subMsg ->
            let
                ( updatedGameBoard, cmd ) =
                    GameBoard.Update.update subMsg model.board
            in
                ( { model | board = updatedGameBoard }, Cmd.map GameBoardMsg cmd )
