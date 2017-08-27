module Page.Edit.Page exposing (init, update, view, addItem)

import Html exposing (Html)
import Message exposing (Msg(..))
import Page.Edit.Update as Update exposing (updateInputValue, updateHistory)
import Page.Edit.View as View exposing (view)
import Model.Edit exposing (EditModel, HistoryItem)
import Model.ShoppingList exposing (ShoppingListModel)


init : EditModel
init =
    EditModel ""
        []


update : EditModel -> String -> EditModel
update model value =
    Update.updateInputValue model value


view : ShoppingListModel -> EditModel -> Html Msg
view shoppingListModel editModel =
    View.view shoppingListModel editModel


addItem : EditModel -> EditModel
addItem editModel =
    let
        history =
            Update.updateHistory editModel.history editModel.value
    in
        { editModel | history = history, value = "" }
