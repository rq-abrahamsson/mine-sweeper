module Update exposing (..)

--Custom imports

import GameBoard.Update
import Models exposing (..)
import GameBoard.Models exposing (generateBoard)
import Messages exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InitBoard ->
            ( { model | board = generateBoard 5 }, Cmd.none )

        GameBoardMsg subMsg ->
            let
                ( updatedGameBoard, cmd ) =
                    GameBoard.Update.update subMsg model.board
            in
                ( { model | board = updatedGameBoard }, Cmd.map GameBoardMsg cmd )
