module Model exposing (Model, Page(..), init)

import Message exposing (Msg(..))
import ShoppingList.Model as SList exposing (Model, init)
import ItemInput.Model as IModel exposing (Model, init)
import Material
import Ports.LocalStorage as LocalStorage


type Page
    = ShoppingListPage
    | EditListPage


type alias Model =
    { currentPage : Page
    , shoppingList : SList.Model
    , mdl : Material.Model
    , itemInput : IModel.Model
    , idCount : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model ShoppingListPage SList.init Material.model IModel.init 0
    , Cmd.batch [ Material.init Mdl, LocalStorage.storageGetItem "history" ]
    )
