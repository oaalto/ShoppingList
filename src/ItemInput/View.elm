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
import ShoppingList.Model exposing (ShoppingListItem)


renderHeader : Model -> Material.Model -> List ShoppingListItem -> Html Msg
renderHeader model mdl items =
    div []
        [ viewTextfield model mdl
        , viewAddButton model mdl items
        , renderDoneButton mdl
        ]


renderBody : Model -> Material.Model -> List ShoppingListItem -> Html Msg
renderBody model mdl shoppingListItems =
    Lists.ul [] (listItems model.history shoppingListItems)


listItems : List HistoryItem -> List ShoppingListItem -> List (Html Msg)
listItems items shoppingListItems =
    items
        |> List.sortWith compareNamesIgnoreCase
        |> List.map (listItem shoppingListItems)


listItem : List ShoppingListItem -> HistoryItem -> Html Msg
listItem shoppingListItems item =
    let
        textColor =
            if isSelected item shoppingListItems then
                "gray"
            else
                "black"
    in
        Lists.li
            [ Options.onClick (historyItemMsg item shoppingListItems)
            , Options.css "color" textColor
            ]
            [ Lists.content []
                [ text item.name ]
            ]


isSelected : HistoryItem -> List ShoppingListItem -> Bool
isSelected historyItem shoppingListItems =
    List.any (\item -> item.name == historyItem.name) shoppingListItems


historyItemMsg : HistoryItem -> List ShoppingListItem -> Msg
historyItemMsg item shoppingListItems =
    if isSelected item shoppingListItems then
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
            , Textfield.label "Add items"
            , Options.onInput UpdateItemInput
            ]
            []
        ]


viewAddButton : Model -> Material.Model -> List ShoppingListItem -> Html Msg
viewAddButton model mdl items =
    let
        baseOptions =
            [ Button.raised
            , Button.ripple
            , Options.onClick AddItem
            ]

        options =
            if isAddButtonDisabled model.value items then
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


isAddButtonDisabled : String -> List ShoppingListItem -> Bool
isAddButtonDisabled value items =
    String.isEmpty value || List.any (\item -> item.name == value) items


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
            ]
            [ text "Done" ]
        ]
