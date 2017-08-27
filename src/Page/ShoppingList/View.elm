module Page.ShoppingList.View exposing (view, renderHeader)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Model.ShoppingList exposing (ShoppingListItem, ShoppingListModel)
import Utils exposing (compareNamesIgnoreCase)
import Page.ShoppingList.Message as Msg exposing (ShoppingListMessage(..))
import Message as GlobalMessage exposing (Msg(EditMode))
import Color
import Material.Icons.Action exposing (check_circle)


view : ShoppingListModel -> Html GlobalMessage.Msg
view model =
    div []
        [ renderHeader
        , renderList model
        ]


renderHeader : Html GlobalMessage.Msg
renderHeader =
    div []
        [ button [ onClick GlobalMessage.EditMode ]
            [ text "Add Items" ]
        , span [ class "remove-buttons" ]
            [ button [ onClick (GlobalMessage.ShoppingList RemoveBoughtItems) ]
                [ text "Remove Marked" ]
            , button [ onClick (GlobalMessage.ShoppingList RemoveAllItems), class "remove-all-button" ]
                [ text "Remove All" ]
            ]
        ]


renderList : ShoppingListModel -> Html GlobalMessage.Msg
renderList model =
    div []
        [ table [ class "shopping-list-table" ] (listItems model.items)
        ]


listItems : List ShoppingListItem -> List (Html GlobalMessage.Msg)
listItems items =
    items
        |> List.sortWith compareNamesIgnoreCase
        |> List.map listItem


listItem : ShoppingListItem -> Html GlobalMessage.Msg
listItem item =
    let
        ( textDecoration, buttonColor ) =
            if item.marked then
                ( "line-through", Color.green )
            else
                ( "initial", Color.grey )
    in
        tr
            [ onClick (GlobalMessage.ShoppingList (ToggleShoppingListItem item.name))
            , style [ ( "text-decoration", textDecoration ) ]
            ]
            [ td []
                [ check_circle buttonColor 16 ]
            , td []
                [ text item.name ]
            ]
