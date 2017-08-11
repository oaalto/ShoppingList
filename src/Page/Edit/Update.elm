module Page.Edit.Update exposing (updateInputValue, updateHistory)

import Model.Edit exposing (EditModel, HistoryItem)


updateInputValue : EditModel -> String -> EditModel
updateInputValue model value =
    { model | value = value }


updateHistory : List HistoryItem -> String -> List HistoryItem
updateHistory history value =
    addHistoryItem history (HistoryItem value)


addHistoryItem : List HistoryItem -> HistoryItem -> List HistoryItem
addHistoryItem history historyItem =
    historyItem :: history
