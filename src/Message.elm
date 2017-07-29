module Message exposing (Msg(..))

import Material
import Ports.LocalStorage as LocalStorage


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleShoppingListItem Int
    | UpdateItemInput String
    | AddItem
    | EditMode
    | ListMode
    | AddHistoryItem Int
    | RemoveHistoryItem Int
    | LoadFromStorage
    | ReceiveFromLocalStorage ( LocalStorage.Key, LocalStorage.Value )
    | RemoveBoughtItems
    | RemoveAllItems
