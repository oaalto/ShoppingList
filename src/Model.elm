module Model exposing (Model, Page(..), init)

import Message exposing (Msg(..))
import Page.ShoppingList.Page as ShoppingListPage exposing (init)
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
    ( Model ShoppingListPage ShoppingListPage.init EditPage.init
    , Cmd.batch [ LocalStorage.storageGetItem "ShoppingList" ]
    )
