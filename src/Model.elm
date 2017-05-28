module Model exposing (Model, init)

import Message exposing (Msg)


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )
