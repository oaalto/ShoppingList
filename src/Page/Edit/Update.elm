module Page.Edit.Update exposing (updateInputValue, updateHistory)

import Model.Edit exposing (EditModel, HistoryItem)
import Model.ShoppingList exposing (ShoppingListItem)
import List


updateInputValue : EditModel -> String -> EditModel
updateInputValue model value =
    { model | value = value }


updateHistory : List ShoppingListItem -> List HistoryItem -> String -> List HistoryItem
updateHistory shoppingListItems history value =
    let
        addedItem =
            List.head shoppingListItems
    in
        case addedItem of
            Just item ->
                addHistoryItem history (HistoryItem value)

            Nothing ->
                history


addHistoryItem : List HistoryItem -> HistoryItem -> List HistoryItem
addHistoryItem history historyItem =
    historyItem :: history
