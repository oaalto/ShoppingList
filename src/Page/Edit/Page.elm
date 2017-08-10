module Page.Edit.Page exposing (init, update, view)

import Html exposing (Html)
import Message exposing (Msg(..))
import Page.Edit.Update as Update exposing (update)
import Page.Edit.View as View exposing (view)
import Model.Edit exposing (EditModel)
import Model.ShoppingList exposing (ShoppingListModel)


init : EditModel
init =
    EditModel ""
        []


update : EditModel -> String -> EditModel
update model value =
    Update.update model value


view : ShoppingListModel -> EditModel -> Html Msg
view shoppingListModel editModel =
    View.view shoppingListModel editModel
