module ItemInput.View exposing (renderHeader, renderBody)

import ItemInput.Model exposing (Model, HistoryItem)
import Html exposing (Html, div, text)
import Message exposing (Msg(..))
import Material
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Button as Button
import Material.List as Lists
import Utils exposing (compareNamesIgnoreCase)


renderHeader : Model -> Material.Model -> Html Msg
renderHeader model mdl =
    div []
        [ viewTextfield model mdl
        , viewAddButton mdl
        , renderDoneButton mdl
        ]


renderBody : Model -> Material.Model -> Html Msg
renderBody model mdl =
    Lists.ul [] (listItems model.history)


listItems : List HistoryItem -> List (Html Msg)
listItems items =
    items
        |> List.sortWith compareNamesIgnoreCase
        |> List.map listItem


listItem : HistoryItem -> Html Msg
listItem item =
    let
        textDecoration =
            if item.selected then
                "line-through"
            else
                "initial"
    in
        Lists.li [ Options.onClick (historyItemMsg item), Options.css "text-decoration" textDecoration ]
            [ Lists.content []
                [ text item.name ]
            ]


historyItemMsg : HistoryItem -> Msg
historyItemMsg item =
    if item.selected then
        RemoveHistoryItem item.id
    else
        AddHistoryItem item.id


viewTextfield : Model -> Material.Model -> Html Msg
viewTextfield model mdl =
    Textfield.render Mdl
        [ 0 ]
        mdl
        [ Textfield.value model.value
        , Options.onInput UpdateItemInput
        ]
        []


viewAddButton : Material.Model -> Html Msg
viewAddButton mdl =
    Button.render Mdl
        [ 0 ]
        mdl
        [ Button.raised
        , Button.ripple
        , Options.onClick AddItem
        ]
        [ text "Add" ]


renderDoneButton : Material.Model -> Html Msg
renderDoneButton mdl =
    Button.render Mdl
        [ 0 ]
        mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Options.onClick ListMode
        ]
        [ text "Done" ]
