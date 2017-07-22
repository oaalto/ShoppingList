module ItemInput.Update exposing (update, toggleSelected)

import ItemInput.Model exposing (Model)
import History.HistoryItem exposing (HistoryItem)


update : Model -> String -> Model
update model value =
    { model | value = value }


toggleSelected : Model -> Int -> Model
toggleSelected model id =
    { model | history = toggleHistoryItem id model.history }


toggleHistoryItem : Int -> List HistoryItem -> List HistoryItem
toggleHistoryItem id history =
    List.map (toggleItem id) history


toggleItem : Int -> HistoryItem -> HistoryItem
toggleItem id item =
    if item.id == id then
        { item | selected = not item.selected }
    else
        item
