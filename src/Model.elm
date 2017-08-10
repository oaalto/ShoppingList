module Model exposing (Model, Page(..), init)

import Message exposing (Msg(..))
import ShoppingList.Model as SList exposing (init)
import Page.Edit.Page as EditPage exposing (init)
import Ports.LocalStorage as LocalStorage
import Model.Edit exposing (EditModel)
import Model.ShoppingList exposing (ShoppingListModel)


type Page
    = ShoppingListPage
    | EditListPage


type alias Model =
    { currentPage : Page
    , shoppingList : ShoppingListModel
    , itemInput : EditModel
    }


init : ( Model, Cmd Msg )
init =
    ( Model ShoppingListPage SList.init EditPage.init
    , Cmd.batch [ LocalStorage.storageGetItem "ShoppingList" ]
    )
