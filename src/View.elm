module View exposing (view)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Model exposing (Model)
import Message exposing (Msg)


view : Model -> Html Msg
view model =
    div []
        []
