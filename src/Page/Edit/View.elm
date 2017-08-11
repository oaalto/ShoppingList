module Page.Edit.View exposing (view)

import Model.Edit exposing (EditModel)
import Html exposing (..)
import Html.Attributes exposing (class, style, type_, placeholder, attribute, disabled)
import Html.Events exposing (onSubmit, onClick, onInput)
import Message exposing (Msg(..))
import Utils exposing (compareNamesIgnoreCase)
import Model.Edit exposing (HistoryItem)
import Model.ShoppingList exposing (ShoppingListItem, ShoppingListModel)
import Material.Icons.Content exposing (add_circle, remove_circle)
import Color


view : ShoppingListModel -> EditModel -> Html Msg
view shoppingListModel editModel =
    div []
        [ renderHeader editModel
        , renderBody shoppingListModel editModel
        ]


renderHeader : EditModel -> Html Msg
renderHeader editModel =
    div []
        [ inputForm editModel
        , button [ onClick ListMode ]
            [ text "Done" ]
        ]


renderBody : ShoppingListModel -> EditModel -> Html Msg
renderBody shoppingListModel editModel =
    table []
        (listItems shoppingListModel editModel)


inputForm : EditModel -> Html Msg
inputForm editModel =
    let
        disabledButton =
            isDisabled editModel

        buttonColor =
            if disabledButton then
                Color.grey
            else
                Color.green
    in
        form [ onSubmit AddItem ]
            [ input [ type_ "text", placeholder "Add items here...", onInput UpdateItemInput ]
                []
            , button [ class "add-button", disabled disabledButton ] [ add_circle buttonColor 16 ]
            ]


isDisabled : EditModel -> Bool
isDisabled editModel =
    case ( String.isEmpty editModel.value, isAlreadyInList editModel.value editModel.history ) of
        ( False, False ) ->
            False

        ( _, _ ) ->
            True


isAlreadyInList : String -> List HistoryItem -> Bool
isAlreadyInList value historyItems =
    List.any (\item -> item.name == value) historyItems


listItems : ShoppingListModel -> EditModel -> List (Html Msg)
listItems shoppingListModel editModel =
    editModel.history
        |> List.filter (filterItems editModel.value)
        |> List.sortWith compareNamesIgnoreCase
        |> List.map (listItem shoppingListModel.items)


filterItems : String -> HistoryItem -> Bool
filterItems value item =
    String.contains value item.name


listItem : List ShoppingListItem -> HistoryItem -> Html Msg
listItem shoppingListItems item =
    let
        ( textColor, buttonColor, buttonFunc ) =
            if isSelected item shoppingListItems then
                ( "gray", Color.red, remove_circle )
            else
                ( "black", Color.green, add_circle )
    in
        tr
            [ onClick (historyItemMsg item shoppingListItems)
            , style [ ( "color", textColor ) ]
            ]
            [ td []
                [ buttonFunc buttonColor 16 ]
            , td []
                [ text item.name ]
            ]


isSelected : HistoryItem -> List ShoppingListItem -> Bool
isSelected historyItem shoppingListItems =
    List.any (\item -> item.name == historyItem.name) shoppingListItems


historyItemMsg : HistoryItem -> List ShoppingListItem -> Msg
historyItemMsg item shoppingListItems =
    if isSelected item shoppingListItems then
        RemoveHistoryItem item.name
    else
        AddHistoryItem item.name
