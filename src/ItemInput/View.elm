module ItemInput.View exposing (renderHeader, renderBody)

import ItemInput.Model exposing (Model)
import Html exposing (Html, div, text, span, form)
import Html.Attributes exposing (class)
import Html.Events exposing (onSubmit)
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


renderHeader : Model -> Material.Model -> Html Msg
renderHeader model mdl =
    div []
        [ viewTextfield model mdl
        , renderDoneButton mdl
        ]


renderBody : Model -> Material.Model -> List ShoppingListItem -> Html Msg
renderBody model mdl shoppingListItems =
    Lists.ul [] (listItems model shoppingListItems)


listItems : Model -> List ShoppingListItem -> List (Html Msg)
listItems model shoppingListItems =
    model.history
        |> List.filter (filterItems model.value)
        |> List.sortWith compareNamesIgnoreCase
        |> List.map (listItem shoppingListItems)


filterItems : String -> HistoryItem -> Bool
filterItems value item =
    String.contains value item.name


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
    form [ onSubmit AddItem, class "input-textfield" ]
        [ Textfield.render Mdl
            [ toInt ItemField ]
            mdl
            [ Textfield.value model.value
            , Textfield.label "Add items"
            , Options.onInput UpdateItemInput
            ]
            []
        , viewAddButton model mdl
        ]


viewAddButton : Model -> Material.Model -> Html Msg
viewAddButton model mdl =
    span [ class "add-item-button" ]
        [ Button.render Mdl
            [ toInt AddButton ]
            mdl
            [ Button.raised
            , Button.ripple
            , Button.disabled |> Options.when (isAddButtonDisabled model.value model.history)
            , Options.onClick AddItem
            ]
            [ text "Add" ]
        ]


isAddButtonDisabled : String -> List HistoryItem -> Bool
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
