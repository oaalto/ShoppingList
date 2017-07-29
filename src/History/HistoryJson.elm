module History.HistoryJson exposing (encode, decode)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline as Pipeline exposing (required, optional)
import History.HistoryItem exposing (HistoryItem)


decodeHistory : Json.Decode.Decoder HistoryItem
decodeHistory =
    Pipeline.decode HistoryItem
        |> required "name" (Json.Decode.string)
        |> required "id" (Json.Decode.int)


encodeHistory : HistoryItem -> Json.Encode.Value
encodeHistory record =
    Json.Encode.object
        [ ( "name", Json.Encode.string <| record.name )
        , ( "id", Json.Encode.int <| record.id )
        ]


type alias HistoryJson =
    { history : List HistoryItem
    }


decode : Json.Decode.Decoder HistoryJson
decode =
    Pipeline.decode HistoryJson
        |> required "history" (Json.Decode.list decodeHistory)


encode : List HistoryItem -> Json.Encode.Value
encode history =
    Json.Encode.object
        [ ( "history", Json.Encode.list <| List.map encodeHistory <| history )
        ]
