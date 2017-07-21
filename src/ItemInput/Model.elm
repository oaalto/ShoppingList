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
        [ HistoryItem "Kahvi" 1 False
        , HistoryItem "Tee" 2 False
        ]
