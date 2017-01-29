module Messages exposing (..)

import GameBoard.Messages


type Msg
    = NoOp
    | InitBoard
    | GameBoardMsg GameBoard.Messages.Msg
