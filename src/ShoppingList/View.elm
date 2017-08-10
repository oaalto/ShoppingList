module ShoppingList.View exposing (view, renderHeader)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Message exposing (Msg(..))
import Model exposing (Model)
import ShoppingList.Model exposing (ShoppingListItem)
import Utils exposing (compareNamesIgnoreCase)


renderHeader : Model -> Html Msg
renderHeader model =
    div []
        [ button [ onClick EditMode ]
            [ text "Edit" ]
        , span [ class "remove-buttons" ]
            [ button [ onClick RemoveBoughtItems ]
                [ text "Remove Marked" ]
            , button [ onClick RemoveAllItems ]
                [ text "Remove All" ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ ul [] (listItems model.shoppingList.items)
        ]


listItems : List ShoppingListItem -> List (Html Msg)
listItems items =
    items
        |> List.sortWith compareNamesIgnoreCase
        |> List.map listItem


listItem : ShoppingListItem -> Html Msg
listItem item =
    let
        textDecoration =
            if item.marked then
                "line-through"
            else
                "initial"
    in
        li [ onClick (ToggleShoppingListItem item.name), style [ ( "text-decoration", textDecoration ) ] ]
            [ text item.name
            ]
