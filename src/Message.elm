module Message exposing (Msg(..))

import Ports.LocalStorage as LocalStorage
import Page.ShoppingList.Message as ShoppingList exposing (ShoppingListMessage)


type Msg
    = UpdateItemInput String
    | AddItem
    | EditMode
    | ListMode
    | AddHistoryItem String
    | RemoveHistoryItem String
    | LoadFromStorage
    | ReceiveFromLocalStorage ( LocalStorage.Key, LocalStorage.Value )
    | ShoppingList ShoppingList.ShoppingListMessage
