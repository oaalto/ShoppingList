module Message exposing (Msg(..))

import Material


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleShoppingListItem Int
    | UpdateItemInput String
    | AddItem
    | EditMode
    | ListMode
    | AddHistoryItem Int
