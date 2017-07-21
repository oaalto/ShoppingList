module ItemInput.View exposing (view)

import ItemInput.Model exposing (Model)
import Html exposing (Html, div, text)
import Message exposing (Msg(..))
import Material
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Button as Button

view : Model -> Material.Model -> Html Msg
view model mdl =
  div []
    [ viewTextfield model mdl
    , viewAddButton mdl
    ]

viewTextfield : Model -> Material.Model -> Html Msg
viewTextfield model mdl =
  Textfield.render Mdl [0] mdl
    [ Textfield.value model.value
    , Options.onInput UpdateItemInput
    ]
    []

viewAddButton : Material.Model -> Html Msg
viewAddButton mdl =
  Button.render Mdl [0] mdl
    [ Button.raised
    , Button.ripple
    , Options.onClick AddItem
    ]
    [ text "Add" ]
