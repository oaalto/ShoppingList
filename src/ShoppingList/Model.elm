module ShoppingList.Model exposing (Model, ShoppingListItem, init)


type alias ShoppingListItem =
    { name : String
    , bought : Bool
    }


type alias Model =
    { items : List ShoppingListItem }


init : Model
init =
    Model [ { name = "Test", bought = False } ]
