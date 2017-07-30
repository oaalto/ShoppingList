module Message exposing (Msg(..))

import Material
import Ports.LocalStorage as LocalStorage


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleShoppingListItem String
    | UpdateItemInput String
    | AddItem
    | EditMode
    | ListMode
    | AddHistoryItem String
    | RemoveHistoryItem String
    | LoadFromStorage
    | ReceiveFromLocalStorage ( LocalStorage.Key, LocalStorage.Value )
    | RemoveBoughtItems
    | RemoveAllItems
