module Json.Encoders.HistoryEncoder exposing (encode)

import Json.Encode
import Model.Edit exposing (HistoryItem)


encode : HistoryItem -> Json.Encode.Value
encode record =
    Json.Encode.object
        [ ( "name", Json.Encode.string <| record.name )
        ]
