module Update exposing (update)

import Model exposing (Model)
import Message exposing (Msg(..))
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
