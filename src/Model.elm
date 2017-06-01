module Model exposing (Model, Page(..), init)

import Message exposing (Msg)
import ShoppingList.Model as SList exposing (Model, init)
import Material


type Page
    = ShoppingListPage


type alias Model =
    { currentPage : Page
    , shoppingList : SList.Model
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model ShoppingListPage SList.init Material.model
    , Cmd.none
    )
