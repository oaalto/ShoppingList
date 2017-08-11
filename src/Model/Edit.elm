module Model.Edit exposing (EditModel, HistoryItem)


type alias HistoryItem =
    { name : String
    }


type alias EditModel =
    { value : String
    , history : List HistoryItem
    }
