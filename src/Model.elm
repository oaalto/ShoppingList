module Model exposing (Model, Page(..), init)

import Message exposing (Msg(..))
import ShoppingList.Model as SList exposing (Model, init)
import ItemInput.Model as IModel exposing (Model, init)
import Ports.LocalStorage as LocalStorage


type Page
    = ShoppingListPage
    | EditListPage


type alias Model =
    { currentPage : Page
    , shoppingList : SList.Model
    , itemInput : IModel.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model ShoppingListPage SList.init IModel.init
    , Cmd.batch [ LocalStorage.storageGetItem "ShoppingList" ]
    )
