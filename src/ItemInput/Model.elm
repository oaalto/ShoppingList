module ItemInput.Model exposing (Model, init)

import History.HistoryItem exposing (HistoryItem)


type alias Model =
    { value : String
    , history : List HistoryItem
    }


init : Model
init =
    Model ""
        []
