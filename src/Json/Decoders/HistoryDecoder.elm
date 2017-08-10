module Json.Decoders.HistoryDecoder exposing (decode)

import Json.Decode
import Json.Decode.Pipeline as Pipeline exposing (required, optional)
import History.HistoryItem exposing (HistoryItem)


decode : Json.Decode.Decoder HistoryItem
decode =
    Pipeline.decode HistoryItem
        |> Pipeline.required "name" (Json.Decode.string)
