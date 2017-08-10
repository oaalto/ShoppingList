module Json.Encoders.ShoppingListEncoder exposing (encode)

import Json.Encode
import Model.ShoppingList exposing (ShoppingListItem)


encode : ShoppingListItem -> Json.Encode.Value
encode record =
    Json.Encode.object
        [ ( "name", Json.Encode.string <| record.name )
        , ( "marked", Json.Encode.bool <| record.marked )
        ]
