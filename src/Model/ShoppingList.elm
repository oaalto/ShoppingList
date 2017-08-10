module Model.ShoppingList exposing (ShoppingListModel, ShoppingListItem)


type alias ShoppingListItem =
    { name : String
    , marked : Bool
    }


type alias ShoppingListModel =
    { items : List ShoppingListItem
    }
