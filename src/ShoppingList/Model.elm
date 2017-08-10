module ShoppingList.Model exposing (Model, ShoppingListItem, init)


type alias ShoppingListItem =
    { name : String
    , marked : Bool
    }


type alias Model =
    { items : List ShoppingListItem
    }


init : Model
init =
    Model []
