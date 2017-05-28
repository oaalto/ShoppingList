module Model exposing (Model, Page(..), init)

import Message exposing (Msg)
import ShoppingList.Model as SList exposing (Model, init)


type Page
    = ShoppingListPage


type alias Model =
    { currentPage : Page
    , shoppingList : SList.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model ShoppingListPage SList.init
    , Cmd.none
    )
