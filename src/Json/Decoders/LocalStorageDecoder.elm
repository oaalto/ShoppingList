module Json.Decoders.LocalStorageDecoder exposing (decode, ShoppingList)

import Json.Decode
import Json.Decode.Pipeline as Pipeline exposing (required, optional)
import Model exposing (Model)
import Json.Decoders.HistoryDecoder as History exposing (decode)
import Json.Decoders.ShoppingListDecoder as ShoppingList exposing (decode)
import History.HistoryItem exposing (HistoryItem)
import ShoppingList.Model exposing (ShoppingListItem)


type alias ShoppingList =
    { history : List HistoryItem
    , shoppingList : List ShoppingListItem
    }


decode : Json.Decode.Decoder ShoppingList
decode =
    Pipeline.decode ShoppingList
        |> Pipeline.required "history" (Json.Decode.list History.decode)
        |> Pipeline.optional "shoppingList" (Json.Decode.list ShoppingList.decode) []
