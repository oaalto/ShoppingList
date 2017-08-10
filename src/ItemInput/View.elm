module ItemInput.View exposing (renderHeader, renderBody)

import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class, style, type_, placeholder)
import Html.Events exposing (onSubmit, onClick)
import Message exposing (Msg(..))
import Utils exposing (compareNamesIgnoreCase)
import History.HistoryItem exposing (HistoryItem)
import ShoppingList.Model exposing (ShoppingListItem)


renderHeader : Model -> Html Msg
renderHeader model =
    div []
        [ input [ type_ "text", placeholder "Add items here..." ]
            []
        , button [ onClick ListMode ]
            [ text "Done" ]
        ]


renderBody : Model -> Html Msg
renderBody model =
    ul [] (listItems model)


listItems : Model -> List (Html Msg)
listItems model =
    model.itemInput.history
        |> List.filter (filterItems model.itemInput.value)
        |> List.sortWith compareNamesIgnoreCase
        |> List.map (listItem model.shoppingList.items)


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
