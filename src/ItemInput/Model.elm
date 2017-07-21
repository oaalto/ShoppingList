module ItemInput.Model exposing (Model, HistoryItem, init)


type alias HistoryItem =
    { name : String
    , id : Int
    , selected : Bool
    }


type alias Model =
    { value : String
    , history : List HistoryItem
    }


init : Model
init =
    Model ""
        [ HistoryItem "Tee" 1 False
        , HistoryItem "Kahvi" 2 False
        ]
