module Json.Decoders.ShoppingListDecoder exposing (decode)

import Json.Decode
import Json.Decode.Pipeline as Pipeline exposing (required, optional)
import ShoppingList.Model exposing (ShoppingListItem)


decode : Json.Decode.Decoder ShoppingListItem
decode =
    Pipeline.decode ShoppingListItem
        |> Pipeline.required "name" (Json.Decode.string)
        |> Pipeline.optional "marked" (Json.Decode.bool) False
