module Page.ShoppingList.Message exposing (ShoppingListMessage(..), ShoppingListExternalMessage(..))


type ShoppingListMessage
    = RemoveBoughtItems
    | RemoveAllItems
    | ToggleShoppingListItem String


type ShoppingListExternalMessage
    = NoOp
    | SaveToStorage
