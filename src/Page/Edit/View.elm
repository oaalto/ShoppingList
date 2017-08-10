module Page.Edit.View exposing (view)

import Model.Edit exposing (EditModel)
import Html exposing (..)
import Html.Attributes exposing (class, style, type_, placeholder)
import Html.Events exposing (onSubmit, onClick, onInput)
import Message exposing (Msg(..))
import Utils exposing (compareNamesIgnoreCase)
import Model.Edit exposing (HistoryItem)
import Model.ShoppingList exposing (ShoppingListItem, ShoppingListModel)


view : ShoppingListModel -> EditModel -> Html Msg
view shoppingListModel editModel =
    div []
        [ renderHeader
        , renderBody shoppingListModel editModel
        ]


renderHeader : Html Msg
renderHeader =
    div []
        [ inputForm
        , button [ onClick ListMode ]
            [ text "Done" ]
        ]


renderBody : ShoppingListModel -> EditModel -> Html Msg
renderBody shoppingListModel editModel =
    ul [] (listItems shoppingListModel editModel)


inputForm : Html Msg
inputForm =
    form [ onSubmit AddItem ]
        [ input [ type_ "text", placeholder "Add items here...", onInput UpdateItemInput ]
            []
        ]


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
        textColor =
            if isSelected item shoppingListItems then
                "gray"
            else
                "black"
    in
        li
            [ onClick (historyItemMsg item shoppingListItems)
            , style [ ( "color", textColor ) ]
            ]
            [ text item.name
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
