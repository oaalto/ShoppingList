module Json.Encoders.LocalStorageEncoder exposing (encode)

import Json.Encode
import Model exposing (Model)
import Json.Encoders.HistoryEncoder as History exposing (encode)
import Json.Encoders.ShoppingListEncoder as ShoppingList exposing (encode)
import Model.Edit exposing (HistoryItem)
import Model.ShoppingList exposing (ShoppingListItem)


encode : List HistoryItem -> List ShoppingListItem -> Json.Encode.Value
encode history items =
    Json.Encode.object
        [ ( "history", Json.Encode.list <| List.map History.encode <| history )
        , ( "shoppingList", Json.Encode.list <| List.map ShoppingList.encode <| items )
        ]
