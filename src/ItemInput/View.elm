module ItemInput.View exposing (renderHeader, renderBody)

import ItemInput.Model exposing (Model)
import Html exposing (Html, div, text, span)
import Html.Attributes exposing (class)
import Message exposing (Msg(..))
import Material
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Button as Button
import Material.List as Lists
import Utils exposing (compareNamesIgnoreCase)
import History.HistoryItem exposing (HistoryItem)
import MdlIds exposing (Id(..), toInt)


renderHeader : Model -> Material.Model -> Html Msg
renderHeader model mdl =
    div []
        [ viewTextfield model mdl
        , viewAddButton model mdl
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
    span [ class "input-textfield" ]
        [ Textfield.render Mdl
            [ toInt ItemField ]
            mdl
            [ Textfield.value model.value
            , Options.onInput UpdateItemInput
            ]
            []
        ]


viewAddButton : Model -> Material.Model -> Html Msg
viewAddButton model mdl =
    let
        baseOptions =
            [ Button.raised
            , Button.ripple
            , Options.onClick AddItem
            ]

        options =
            if String.isEmpty model.value then
                Button.disabled :: baseOptions
            else
                baseOptions
    in
        span [ class "add-item-button" ]
            [ Button.render Mdl
                [ toInt AddButton ]
                mdl
                options
                [ text "Add" ]
            ]


renderDoneButton : Material.Model -> Html Msg
renderDoneButton mdl =
    span [ class "done-button" ]
        [ Button.render Mdl
            [ toInt DoneButton ]
            mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Options.onClick ListMode
            , Options.cs "done-button"
            ]
            [ text "Done" ]
        ]
