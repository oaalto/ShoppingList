module App exposing (..)

import Html exposing (Html)
import View exposing (view)
import Model exposing (Model, init)
import Update exposing (update)
import Message exposing (Msg)
import Material
import Message exposing (Msg(..))


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = Material.subscriptions Mdl
        }
